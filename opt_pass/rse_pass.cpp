#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/IRBuilder.h"

#include "llvm/IR/Metadata.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/AsmParser/LLToken.h"
#include "llvm/ADT/ilist_node.h"

//#include "llvm/Support/raw_ostream.h"

using namespace llvm;
using namespace std;

namespace {

	void initialization(Function &F);

	struct RSE_pass : PassInfoMixin<RSE_pass> {

		bool initial = false;
		int func_num = 0;

		Type *intTy, *ptrTy, *voidTy, *boolTy;

		FunctionCallee p_init;
		FunctionCallee p_probe_mutex;
		FunctionCallee p_probe_func;
		FunctionCallee p_probe_spawning;
		FunctionCallee p_probe_spawned;

		// Main entry point, takes IR unit to run the pass on (&F) and the
		// corresponding pass manager (to be queried if need be)
		PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
			/*
			string FName = F.getName().str();
			if(FName.find("core") != string::npos || FName.find("std") != string::npos) {
				return PreservedAnalyses::all();
			}
			*/		

			if(!initial) {
				initialization(F);
				initial = true;
			}

			for(auto& B : F) {
				for(auto& I : B) {
					if(I.getOpcode() == Instruction::Call){
						CallInst * cal = dyn_cast<CallInst>(&I);
						if(cal->getCalledFunction() != NULL){ // childe thread spawned
							string funcName = cal->getCalledFunction()->getName().str();
							if(funcName.find("drop_in_place") == std::string::npos
										&& funcName.find("closure") != std::string::npos 
										&& funcName.find("main") != std::string::npos){ //main.*closure no dip
								IRBuilder<> builder(cal);

								Value* args[] = {
									ConstantInt::get(intTy, -1, false),
									ConstantInt::get(intTy, func_num++, false),
								};
								builder.CreateCall(p_probe_spawned, args);
							}
						}
					}
					if(I.getOpcode() == Instruction::Invoke) {
						InvokeInst * inv = dyn_cast<InvokeInst>(&I);
						if(inv->getDebugLoc().get() != NULL && inv->getCalledFunction() != NULL) {
							string funcName = inv->getCalledFunction()->getName().str();
							if(funcName.find("_ZN3std4sync5mutex14Mutex$LT$T$GT$4lock") != std::string::npos) { // lock
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();
								Value * var = inv->getArgOperand(1);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false), // line number
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("lock", ""),
									builder.CreateBitCast(var, ptrTy),
								};
								builder.CreateCall(p_probe_mutex, args);
							} 
							else if(funcName.find("_ZN4core3ptr60drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();
								Value * var = inv->getArgOperand(0);

								Value * MutexGuard = builder.CreateLoad(var->getType()->getPointerElementType(), var);
								Value * lockPtr = builder.CreateStructGEP(MutexGuard->getType(), var, 0);
								Value * lock = builder.CreateLoad(lockPtr->getType()->getPointerElementType(), lockPtr);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false), // line number
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("unlock", ""),
									builder.CreateBitCast(lock, ptrTy),
								};
								builder.CreateCall(p_probe_mutex, args);
							} 
							else if(funcName.find("_ZN3std4sync4mpsc15Sender$LT$T$GT$4send"/*17h222a72a470795b19E*/) != std::string::npos){ //send
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("send", ""),
								};
								builder.CreateCall(p_probe_func, args);
							} 
							else if(funcName.find("_ZN3std4sync4mpsc17Receiver$LT$T$GT$4recv"/*17h61c33427f2e2f6c6E*/) != std::string::npos){//recv
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("recv", "")
								};
								builder.CreateCall(p_probe_func, args);
							} 
							else if(funcName.find("_ZN3std6thread5spawn"/*17he91e346dc8743a67E"*/) != std::string::npos){ //spawn
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									//builder.CreateGlobalStringPtr("spawn", "")
								};
								builder.CreateCall(p_probe_spawning, args);
							} 
							else if(funcName.find("_ZN3std6thread19JoinHandle$LT$T$GT$4join"/*17hd223c567ab090f8cE"*/) != std::string::npos){ //join
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
								 	ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("join", "")
								};
								builder.CreateCall(p_probe_func, args);
							}
						}
					} // opcode == Instruction::Invoke 
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
			p_init = F.getParent()->getOrInsertFunction("_ZN9probe_RSE6_init_17hf804c7106d130da0E", fty);

			vector<Type*> paramTypes = {intTy, intTy, ptrTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_mutex = F.getParent()->getOrInsertFunction("_ZN9probe_RSE13_probe_mutex_17h00a1a9c41158238fE", fty);

			paramTypes = {intTy, intTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_func = F.getParent()->getOrInsertFunction("_ZN9probe_RSE12_probe_func_17h817346fa42d66a09E", fty);
			
			paramTypes = {intTy, intTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_spawning = F.getParent()->getOrInsertFunction("_ZN9probe_RSE16_probe_spawning_17he1598d66b0ab4500E", fty);

			paramTypes = {intTy, intTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_spawned = F.getParent()->getOrInsertFunction("_ZN9probe_RSE15_probe_spawned_17hfa456b2bbcd59460E", fty);

			Function * mainFunc = F.getParent()->getFunction(StringRef("main"));
			if(mainFunc != NULL) {
				IRBuilder<> builder(mainFunc->getEntryBlock().getFirstNonPHI());
				vector<Value *> ArgsV;
				builder.CreateCall(p_init, ArgsV, "");
			}
		}
	}; //RSE_pass

} // namespace

// -----------------------------------------------------------------------------------

llvm::PassPluginLibraryInfo get_custom_pass_PluginInfo() {
	return {
		LLVM_PLUGIN_API_VERSION, "RSE_pass", LLVM_VERSION_STRING, [](PassBuilder &PB) { 
			PB.registerPipelineParsingCallback( [](StringRef Name, FunctionPassManager &FPM, ArrayRef<PassBuilder::PipelineElement>) { 
				if (Name == "RSE_pass") { 
					FPM.addPass(RSE_pass()); 
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
