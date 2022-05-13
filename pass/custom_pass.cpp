
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/IRBuilder.h"

#include "llvm/IR/Metadata.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/AsmParser/LLToken.h"

//#include "llvm/Support/raw_ostream.h"

using namespace llvm;
using namespace std;

namespace {

	void initialization(Function &F);

	struct Custom_pass : PassInfoMixin<Custom_pass> {

		bool initial = false;

		Type *intTy, *ptrTy, *voidTy, *boolTy;

		//Constant * p_init;
		//Constant * p_probe;
		FunctionCallee p_init;
		FunctionCallee p_probe;
		FunctionCallee p_probe_lock;
		FunctionCallee p_probe_unlock;
		FunctionCallee p_probe_send;
		FunctionCallee p_probe_recv;
		FunctionCallee p_probe_thread_spawn;
		FunctionCallee p_probe_thread_join;

		// Main entry point, takes IR unit to run the pass on (&F) and the
		// corresponding pass manager (to be queried if need be)
		PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {

			string FName = F.getName().str();
			/*
			if(FName.find("core") != string::npos || FName.find("std") != string::npos) {
				return PreservedAnalyses::all();
			}*/

			if(!initial) {
				initialization(F);
				initial = true;
			}

			int func_num = 0;
			for(auto& B : F) {
				for(auto& I : B) {
					if(I.getOpcode() == Instruction::Invoke) {
						InvokeInst * inv = dyn_cast<InvokeInst>(&I);
						if(inv->getDebugLoc().get() != NULL && inv->getCalledFunction() != NULL) {
							string funcName = inv->getCalledFunction()->getName().str();
							if(funcName.find("_ZN3std4sync5mutex14Mutex$LT$T$GT$4lock") != std::string::npos) { // lock
								//errs() << "lock\n";
								int loc = inv->getDebugLoc().getLine();
								Value * var = inv->getArgOperand(1);
								IRBuilder<> builder(inv);
								Value * varAddr = builder.CreateBitCast(var, ptrTy);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false), // line number
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("lock", ""),
									varAddr
								};

								builder.CreateCall(p_probe_lock, args);

							} else if(funcName.find("_ZN4core3ptr60drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								int loc = inv->getDebugLoc().getLine();
								Value * var = inv->getArgOperand(0);
								IRBuilder<> builder(inv);

								Value * MutexGuard = builder.CreateLoad(var->getType()->getPointerElementType(), var);
								Value * lockPtr = builder.CreateStructGEP(MutexGuard->getType(), var, 0);
								Value * lock = builder.CreateLoad(lockPtr->getType()->getPointerElementType(), lockPtr);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false), // line number
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("unlock", ""),
									builder.CreateBitCast(lock, ptrTy),
								};
								builder.CreateCall(p_probe_unlock, args);
							} else if(funcName.find("_ZN3std4sync4mpsc15Sender$LT$T$GT$4send"/*17h222a72a470795b19E*/) != std::string::npos){ //send
								int loc = inv->getDebugLoc().getLine();
								IRBuilder<> builder(inv);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("send", ""),
								};
								builder.CreateCall(p_probe_send, args);
							} else if(funcName.find("_ZN3std4sync4mpsc17Receiver$LT$T$GT$4recv"/*17h61c33427f2e2f6c6E*/) != std::string::npos){//recv
								int loc = inv->getDebugLoc().getLine();
								IRBuilder<> builder(inv);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("recv", "")
								};
								builder.CreateCall(p_probe_recv, args);
							} else if(funcName.find("_ZN3std6thread5spawn17he91e346dc8743a67E") != std::string::npos){ //spawn
								int loc = inv->getDebugLoc().getLine();
								IRBuilder<> builder(inv);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("spawn", "")
								};
								builder.CreateCall(p_probe_thread_spawn, args);
							} else if(funcName.find("_ZN3std6thread19JoinHandle$LT$T$GT$4join17hd223c567ab090f8cE") != std::string::npos){ //join
								int loc = inv->getDebugLoc().getLine();
								IRBuilder<> builder(inv);

								Value* args[] = {
								 	ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("join", "")
								};
								builder.CreateCall(p_probe_thread_join, args);
							}
						}
					} else if(I.getOpcode() == Instruction::Call) {
					} else {
						//errs() << "not store or load\n";
					}
				}
			}
			return PreservedAnalyses::none();
		}

		// Without isRequired returning true, this pass will be skipped for functions
		// decorated with the optnone LLVM attribute. Note that clang -O0 decorates
		// all functions with optnone.
		static bool isRequired() { return true; }

		void initialization(Function &F) {
			intTy = Type::getInt32Ty(F.getContext());
			ptrTy = Type::getInt8PtrTy(F.getContext());
			voidTy = Type::getVoidTy(F.getContext());
			boolTy = Type::getInt1Ty(F.getContext());

			LLVMContext &Ctx = F.getContext();

			FunctionType * fty = FunctionType::get(voidTy, false);
			p_init = F.getParent()->getOrInsertFunction("_init_", fty);

			vector<Type*> paramTypes = {intTy, ptrTy, ptrTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe = F.getParent()->getOrInsertFunction("_probe_", fty);

			paramTypes = {intTy, intTy, ptrTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_lock = F.getParent()->getOrInsertFunction("_probe_lock_", fty);

			paramTypes = {intTy, intTy, ptrTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_unlock = F.getParent()->getOrInsertFunction("_probe_unlock_", fty);
			
			paramTypes = {intTy, intTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_send = F.getParent()->getOrInsertFunction("_probe_send_", fty);

		 	paramTypes = {intTy, intTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_recv = F.getParent()->getOrInsertFunction("_probe_recv_", fty);

			paramTypes = {intTy, intTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_thread_spawn = F.getParent()->getOrInsertFunction("_probe_thread_spawn_", fty);

			paramTypes = {intTy, intTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_thread_join = F.getParent()->getOrInsertFunction("_probe_thread_join_", fty);

			Function * mainFunc = F.getParent()->getFunction(StringRef("main"));
			if(mainFunc != NULL) {
				IRBuilder<> builder(mainFunc->getEntryBlock().getFirstNonPHI());
				vector<Value *> ArgsV;
				builder.CreateCall(p_init, ArgsV, "");
			}
			errs() << "init!\n";
		}
	}; //Custom_pass

} // namespace

// -----------------------------------------------------------------------------------

llvm::PassPluginLibraryInfo get_custom_pass_PluginInfo() {
  return {
  		LLVM_PLUGIN_API_VERSION, "Custom_pass", LLVM_VERSION_STRING, 
			[](PassBuilder &PB) {
				PB.registerPipelineParsingCallback(
					[](StringRef Name, FunctionPassManager &FPM,
					   ArrayRef<PassBuilder::PipelineElement>) {
					  if (Name == "Custom_pass") {
						FPM.addPass(Custom_pass());
						return true;
					  }
					  return false;
					});
		  }
	  };
}

// This is the core interface for pass plugins. It guarantees that 'opt' will
// be able to recognize HelloWorld when added to the pass pipeline on the
// command line, i.e. via '-passes=hello-world'
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return get_custom_pass_PluginInfo();
}
