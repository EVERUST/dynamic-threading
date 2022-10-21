#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/IRBuilder.h"

#include "llvm/IR/Metadata.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/AsmParser/LLToken.h"
#include "llvm/ADT/ilist_node.h"

#include <iostream>
#include <fstream>

//#include "llvm/Support/raw_ostream.h"

using namespace llvm;
using namespace std;

namespace {

	void initialize_rse(Function &F);
	void initialize_tle(Function &F);

	struct RSE_pass : PassInfoMixin<RSE_pass> {

		bool initial = false, is_rse_pass = false;
		int func_num = 0;
		string file_path;
		ofstream function_index_fp;

		Type *intTy, *ptrTy, *voidTy, *boolTy;
		FunctionCallee p_init, p_probe_mutex, p_probe_func, p_probe_spawning, p_probe_spawned;

		RSE_pass(bool is_rse){
			is_rse_pass = is_rse;
		}

		/** ---------------------------- call ---------------------------- **/
		void insert_func(CallInst* cal, string func_name, string symbol){
			IRBuilder<> builder(cal);
			if(is_rse_pass) 
				function_index_fp << func_num << " " << symbol << " " << func_name << "\t" << file_path << "\t" << cal->getDebugLoc().getLine() << endl;

			Value* args[] = {
				ConstantInt::get(intTy, cal->getDebugLoc().getLine(), false),
				ConstantInt::get(intTy, func_num++, false),
				builder.CreateGlobalStringPtr(func_name, ""),
				builder.CreateGlobalStringPtr(file_path, ""),
			};
			builder.CreateCall(p_probe_func, args);
		}

		void insert_spawned(CallInst* cal, string symbol){
			IRBuilder<> builder(cal);
			if(is_rse_pass) 
				function_index_fp <<  func_num << " " << symbol << " spawned\t" <<file_path << "\t" << cal->getDebugLoc().getLine() << endl;

			Value* args[] = {
				ConstantInt::get(intTy, -1, false),
				ConstantInt::get(intTy, func_num++, false),
			};
			builder.CreateCall(p_probe_spawned, args);
		}

		void insert_unlock(CallInst* cal, string symbol){
			IRBuilder<> builder(cal);
			if(is_rse_pass) 
				function_index_fp << func_num << " " << symbol << " unlock\t" << file_path << "\t" << cal->getDebugLoc().getLine() << endl;

			Value * var = cal->getArgOperand(0);
			Value * MutexGuard = builder.CreateLoad(var->getType()->getPointerElementType(), var);
			Value * lockPtr = builder.CreateStructGEP(MutexGuard->getType(), var, 0);
			Value * lock = builder.CreateLoad(lockPtr->getType()->getPointerElementType(), lockPtr);

			Value* args[] = {
				ConstantInt::get(intTy, cal->getDebugLoc().getLine(), false), 
				ConstantInt::get(intTy, func_num++, false),
				builder.CreateGlobalStringPtr("unlock", ""),
				builder.CreateBitCast(lock, ptrTy),
				builder.CreateGlobalStringPtr(file_path, ""),
			};
			builder.CreateCall(p_probe_mutex, args);
		}

		/** ---------------------------- invoke ---------------------------- **/
		void insert_func(InvokeInst* inv, string func_name, string symbol){
			IRBuilder<> builder(inv);
			if(is_rse_pass) 
				function_index_fp << func_num << " " << symbol << " " << func_name << "\t" << file_path << "\t" << inv->getDebugLoc().getLine() << endl;

			Value* args[] = {
				ConstantInt::get(intTy, inv->getDebugLoc().getLine(), false),
				ConstantInt::get(intTy, func_num++, false),
				builder.CreateGlobalStringPtr(func_name, ""),
				builder.CreateGlobalStringPtr(file_path, ""),
			};
			builder.CreateCall(p_probe_func, args);
		}

		void insert_spawning(InvokeInst* inv, string symbol){
			IRBuilder<> builder(inv);
			if(is_rse_pass) 
				function_index_fp << func_num << " " << symbol << " spawning\t" << file_path << "\t" << inv->getDebugLoc().getLine() << endl;

			Value* args[] = {
				ConstantInt::get(intTy, inv->getDebugLoc().getLine(), false),
				ConstantInt::get(intTy, func_num++, false),
				builder.CreateGlobalStringPtr(file_path, ""),
			};
			builder.CreateCall(p_probe_spawning, args);
		}

		void insert_spawned(InvokeInst* inv, string symbol){
			IRBuilder<> builder(inv);
			if(is_rse_pass) 
				function_index_fp << func_num << " " << symbol << " spawned\t" << file_path << "\t" << inv->getDebugLoc().getLine() << endl;

			Value* args[] = {
				ConstantInt::get(intTy, -1, false),
				ConstantInt::get(intTy, func_num++, false),
			};
			builder.CreateCall(p_probe_spawned, args);
		}

		void insert_lock(InvokeInst* inv, string symbol){
			IRBuilder<> builder(inv);
			if(is_rse_pass) 
				function_index_fp << func_num << " " << symbol << " lock__\t" << file_path << "\t" << inv->getDebugLoc().getLine() << endl;

			Value * var = inv->getArgOperand(1);

			Value* args[] = {
				ConstantInt::get(intTy, inv->getDebugLoc().getLine(), false), // line number
				ConstantInt::get(intTy, func_num++, false),
				builder.CreateGlobalStringPtr("lock", ""),
				builder.CreateBitCast(var, ptrTy),
				builder.CreateGlobalStringPtr(file_path, ""),
			};
			builder.CreateCall(p_probe_mutex, args);
		}

		void insert_unlock(InvokeInst* inv, string symbol){
			IRBuilder<> builder(inv);
			if(is_rse_pass) 
				function_index_fp << func_num << " " << symbol << " unlock\t" << file_path << "\t" << inv->getDebugLoc().getLine() << endl;

			Value * var = inv->getArgOperand(0);
			Value * MutexGuard = builder.CreateLoad(var->getType()->getPointerElementType(), var);
			Value * lockPtr = builder.CreateStructGEP(MutexGuard->getType(), var, 0);
			Value * lock = builder.CreateLoad(lockPtr->getType()->getPointerElementType(), lockPtr);

			Value* args[] = {
				ConstantInt::get(intTy, inv->getDebugLoc().getLine(), false), // line number
				ConstantInt::get(intTy, func_num++, false),
				builder.CreateGlobalStringPtr("unlock", ""),
				builder.CreateBitCast(lock, ptrTy),
				builder.CreateGlobalStringPtr(file_path, ""),
			};
			builder.CreateCall(p_probe_mutex, args);
		}

		// Main entry point, takes IR unit to run the pass on (&F) and the
		// corresponding pass manager (to be queried if need be)
		PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
			if(!initial) {
				if(is_rse_pass) initialize_rse(F);
				else initialize_tle(F);
				initial = true;
			}

			if(is_rse_pass) 
				function_index_fp.open("function_number_ind", ios_base::app);

			SmallVector<std::pair<unsigned, MDNode *>, 4> MDs;
			string file;
			string directory;
			F.getAllMetadata(MDs);
			for (auto &MD : MDs) {
				if (MDNode *N = MD.second) {
					if (auto *subProgram = dyn_cast<DISubprogram>(N)) {
						file = subProgram->getFilename().str();
						directory = subProgram->getDirectory().str();
						break;
					}
				}
			}
			file_path = directory + "/" + file;

			for(auto& B : F) {
				for(auto& I : B) {
					if(I.getOpcode() == Instruction::Call){
						CallInst * cal = dyn_cast<CallInst>(&I);
						if(cal->getCalledFunction() != NULL){
							string funcName = cal->getCalledFunction()->getName().str();
							if(funcName.find("drop_in_place") == std::string::npos
										&& funcName.find("closure") != std::string::npos 
										&& funcName.find("main") != std::string::npos){ //main.*closure no dip
								insert_spawned(cal, "a");
								errs() << func_num << "a - added call main-----------------------------------------------\n";
							}
							else if(funcName.find("spawn_receiver") != std::string::npos
										&& funcName.find("closure") != std::string::npos
										&& funcName.find("drop_in_place") == std::string::npos){
								insert_spawned(cal, "b");
								errs() << func_num << "b - added call main-----------------------------------------------\n";
							}
							else if(funcName.find("_ZN15crossbeam_utils6thread19ScopedThreadBuilder5spawn") != std::string::npos){ // crossbeam spawn
							 	insert_spawned(cal, "d");
								errs() << func_num << "d - added call main-----------------------------------------------\n";
							}
							else if(funcName.find("_ZN3std4sync4mpsc17Receiver$LT$T$GT$4recv") != std::string::npos){//recv
								insert_func(cal, "recv__", "e");
								errs() << func_num << "e - added call recv-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr65drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								insert_unlock(cal, "f");
								errs() << func_num << "f - added call unlock-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr115drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								insert_unlock(cal, "g");
								errs() << func_num << "g - added call unlock-----------------------------------------------\n";
							} 
						}
					}
					else if(I.getOpcode() == Instruction::Invoke) {
						InvokeInst * inv = dyn_cast<InvokeInst>(&I);
						if(inv->getDebugLoc().get() != NULL && inv->getCalledFunction() != NULL) {
							string funcName = inv->getCalledFunction()->getName().str();
							if(funcName.find("_ZN3std4sync5mutex14Mutex$LT$T$GT$4lock") != std::string::npos) { // lock
								insert_lock(inv, "h");
								errs() << func_num << "h - added invo lock-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr65drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								insert_unlock(inv, "i");
								errs() << func_num << "i - added invo unlock-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr115drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								insert_unlock(inv, "j");
								errs() << func_num << "j - added invo unlock-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN3std4sync4mpsc15Sender$LT$T$GT$4send") != std::string::npos){ //send
								insert_func(inv, "send__", "k");
								errs() << func_num << "k - added invo send-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN3std4sync4mpsc17Receiver$LT$T$GT$4recv") != std::string::npos){//recv
								insert_func(inv, "recv__", "l");
								errs() << func_num << "l - added invo recv-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN3std6thread5spawn") != std::string::npos){ //spawning
								insert_spawning(inv, "m");
								errs() << func_num << "m - added invo spawn-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN15crossbeam_utils6thread5Scope5spawn") != std::string::npos){ // crossbeam spawning
								insert_spawning(inv, "n");
								errs() << func_num << "n - added invo spawn-----------------------------------------------\n";
							} 
							/*
							else if(funcName.find("_ZN6ignore4walk12WalkParallel5visit28_$u7b$$u7b$closure") != std::string::npos){ // ignore visit spawned
								insert_spawned(inv);
								errs() << "added call main-----------------------------------------------\n";
							} 
							else if(funcName.find("_ZN3std6thread6Thread3new") != std::string::npos){ //spawned
								insert_spawned(inv, "o");
								errs() << func_num << "o - added call main-----------------------------------------------\n";
							} 
							*/
						}
					} // opcode == Instruction::Invoke 
				}
			}
			ofstream write_func_num;
			if(is_rse_pass){
				function_index_fp.close();
				write_func_num.open("func_num_rse");
			}
			else {
				write_func_num.open("func_num_tle");
			}
			write_func_num << func_num;
			write_func_num.close();
			return PreservedAnalyses::none();
		}

		// Without isRequired returning true, this pass will be skipped for functions
		// decorated with the optnone LLVM attribute. Note that clang -O0 decorates
		// all functions with optnone.
		static bool isRequired() { return true; }

		void initialize_rse(Function &F) {
			string line;
			ifstream read_func_num ("func_num_rse");
			if(read_func_num.is_open()){
				getline(read_func_num, line);
				func_num = stoi(line);
			}
			read_func_num.close();

			intTy = Type::getInt32Ty(F.getContext());
			ptrTy = Type::getInt8PtrTy(F.getContext());
			voidTy = Type::getVoidTy(F.getContext());
			boolTy = Type::getInt1Ty(F.getContext());

			LLVMContext &Ctx = F.getContext();

			FunctionType * fty = FunctionType::get(voidTy, false);
			p_init = F.getParent()->getOrInsertFunction("_ZN9probe_RSE6_init_17h4b2a35616602d784E", fty);

			vector<Type*> paramTypes = {intTy, intTy, ptrTy, ptrTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_mutex = F.getParent()->getOrInsertFunction("_ZN9probe_RSE13_probe_mutex_17hebb682d9900a17b3E", fty);

			paramTypes = {intTy, intTy, ptrTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_func = F.getParent()->getOrInsertFunction("_ZN9probe_RSE12_probe_func_17h76edebab8a1c6c6aE", fty);
			
			paramTypes = {intTy, intTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_spawning = F.getParent()->getOrInsertFunction("_ZN9probe_RSE16_probe_spawning_17h0bb1a5cc15bc0ecaE", fty);

			paramTypes = {intTy, intTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_spawned = F.getParent()->getOrInsertFunction("_ZN9probe_RSE15_probe_spawned_17h4b10d4dcbc8435a1E", fty);

			Function * mainFunc = F.getParent()->getFunction(StringRef("main"));
			if(mainFunc != NULL) {
				IRBuilder<> builder(mainFunc->getEntryBlock().getFirstNonPHI());
				vector<Value *> ArgsV;
				builder.CreateCall(p_init, ArgsV, "");
			}
		}

		void initialize_tle(Function &F) {
			string line;
			ifstream read_func_num ("func_num_tle");
			if(read_func_num.is_open()){
				getline(read_func_num, line);
				func_num = stoi(line);
			}
			read_func_num.close();

			intTy = Type::getInt32Ty(F.getContext());
			ptrTy = Type::getInt8PtrTy(F.getContext());
			voidTy = Type::getVoidTy(F.getContext());
			boolTy = Type::getInt1Ty(F.getContext());

			LLVMContext &Ctx = F.getContext();

			FunctionType * fty = FunctionType::get(voidTy, false);
			p_init = F.getParent()->getOrInsertFunction("_ZN9probe_ERR6_init_17h620290c0f842cc7eE", fty);

			vector<Type*> paramTypes = {intTy, intTy, ptrTy, ptrTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_mutex = F.getParent()->getOrInsertFunction("_ZN9probe_ERR13_probe_mutex_17h1d42b4d2bb9896abE", fty);

			paramTypes = {intTy, intTy, ptrTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_func = F.getParent()->getOrInsertFunction("_ZN9probe_ERR12_probe_func_17h370a3cccf4e0c069E", fty);
			
			paramTypes = {intTy, intTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_spawning = F.getParent()->getOrInsertFunction("_ZN9probe_ERR16_probe_spawning_17h1f3e426fcd70b69fE", fty);
			
			paramTypes = {intTy, intTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_spawned = F.getParent()->getOrInsertFunction("_ZN9probe_ERR15_probe_spawned_17h5319457ca87fec88E", fty);

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
		LLVM_PLUGIN_API_VERSION, "my_pass", LLVM_VERSION_STRING, [](PassBuilder &PB) { 
			PB.registerPipelineParsingCallback( [](StringRef Name, FunctionPassManager &FPM, ArrayRef<PassBuilder::PipelineElement>) { 
				if (Name == "RSE_pass") { 
					FPM.addPass(RSE_pass(true)); 
					return true; 
				} 
				else if (Name == "TLE_pass"){
					//FPM.addPass(TLE_pass());
					FPM.addPass(RSE_pass(false)); 
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
