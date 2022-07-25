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
			if(!initial) {
				initialization(F);
				initial = true;
			}

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
			string filePath = directory + "/" + file;

			for(auto& B : F) {
				for(auto& I : B) {
					if(I.getOpcode() == Instruction::Call){
						CallInst * cal = dyn_cast<CallInst>(&I);
						if(cal->getCalledFunction() != NULL){
							string funcName = cal->getCalledFunction()->getName().str();
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
							else if(funcName.find("_ZN2fd4walk14spawn_receiver28_$u7b$$u7b$closure$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$17h9100c921955b30a8E") != std::string::npos){ // fd spawn
								IRBuilder<> builder(cal);

								Value* args[] = {
									ConstantInt::get(intTy, -1, false),
									ConstantInt::get(intTy, func_num++, false),
								};
								builder.CreateCall(p_probe_spawned, args);
								errs() << "added call main-------------------------------------------------------------------------------------------------------------------------------\n";
							}
							else if(funcName.find("_ZN2fd4walk14spawn_receiver28_$u7b$$u7b$closure$u7d$$u7d$17h953a9ddec09dc92cE") != std::string::npos){ // fd spawn
								IRBuilder<> builder(cal);

								Value* args[] = {
									ConstantInt::get(intTy, -1, false),
									ConstantInt::get(intTy, func_num++, false),
								};
								builder.CreateCall(p_probe_spawned, args);
								errs() << "added call main-------------------------------------------------------------------------------------------------------------------------------\n";
							}
							else if(funcName.find("_ZN15crossbeam_utils6thread19ScopedThreadBuilder5spawn") != std::string::npos){ // crossbeam spawn
								IRBuilder<> builder(cal);

								Value* args[] = {
									ConstantInt::get(intTy, -1, false),
									ConstantInt::get(intTy, func_num++, false),
								};
								builder.CreateCall(p_probe_spawned, args);
								errs() << "added call main-------------------------------------------------------------------------------------------------------------------------------\n";
							}
							else if(funcName.find("_ZN3std4sync4mpsc17Receiver$LT$T$GT$4recv") != std::string::npos){//recv
								IRBuilder<> builder(cal);

								int loc = cal->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("recv", ""),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_func, args);
								errs() << "added call recv-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr65drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								IRBuilder<> builder(cal);

								int loc = cal->getDebugLoc().getLine();
								Value * var = cal->getArgOperand(0);

								Value * MutexGuard = builder.CreateLoad(var->getType()->getPointerElementType(), var);
								Value * lockPtr = builder.CreateStructGEP(MutexGuard->getType(), var, 0);
								Value * lock = builder.CreateLoad(lockPtr->getType()->getPointerElementType(), lockPtr);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false), // line number
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("unlock", ""),
									builder.CreateBitCast(lock, ptrTy),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
								errs() << "added call unlock-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr115drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								IRBuilder<> builder(cal);

								int loc = cal->getDebugLoc().getLine();
								Value * var = cal->getArgOperand(0);

								Value * MutexGuard = builder.CreateLoad(var->getType()->getPointerElementType(), var);
								Value * lockPtr = builder.CreateStructGEP(MutexGuard->getType(), var, 0);
								Value * lock = builder.CreateLoad(lockPtr->getType()->getPointerElementType(), lockPtr);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false), // line number
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("unlock", ""),
									builder.CreateBitCast(lock, ptrTy),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
								errs() << "added call unlock-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
						}
					}
					else if(I.getOpcode() == Instruction::Invoke) {
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
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
								errs() << "added invo lock-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr65drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
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
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
								errs() << "added invo unlock-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr115drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
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
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
								errs() << "added invo unlock-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN3std4sync4mpsc15Sender$LT$T$GT$4send") != std::string::npos){ //send
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("send", ""),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_func, args);
								errs() << "added invo send-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN3std4sync4mpsc17Receiver$LT$T$GT$4recv") != std::string::npos){//recv
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("recv", ""),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_func, args);
								errs() << "added invo recv-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN3std6thread5spawn") != std::string::npos){ //spawning
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_spawning, args);
								errs() << "added invo spawn-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN15crossbeam_utils6thread5Scope5spawn") != std::string::npos){ // crossbeam spawning
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_spawning, args);
								errs() << "added invo spawn-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							/*
							else if(funcName.find("_ZN3std6thread6Thread3new") != std::string::npos){ //spawned
								IRBuilder<> builder(inv);

								Value* args[] = {
									ConstantInt::get(intTy, -1, false),
									ConstantInt::get(intTy, func_num++, false),
								};
								builder.CreateCall(p_probe_spawned, args);
								errs() << "added call main-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							*/
						}
					} // opcode == Instruction::Invoke 
				}
			}
			ofstream write_func_num;
			write_func_num.open("func_num_rse");
			write_func_num << func_num;
			write_func_num.close();
			return PreservedAnalyses::none();
		}

		// Without isRequired returning true, this pass will be skipped for functions
		// decorated with the optnone LLVM attribute. Note that clang -O0 decorates
		// all functions with optnone.
		static bool isRequired() { return true; }

		void initialization(Function &F) {
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
	}; //RSE_pass	

	struct TLE_pass : PassInfoMixin<TLE_pass> {

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
			if(!initial) {
				initialization(F);
				initial = true;
			}

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
			string filePath = directory + "/" + file;

			for(auto& B : F) {
				for(auto& I : B) {
					if(I.getOpcode() == Instruction::Call){
						CallInst * cal = dyn_cast<CallInst>(&I);
						if(cal->getCalledFunction() != NULL){
							string funcName = cal->getCalledFunction()->getName().str();
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
							else 
							if(funcName.find("_ZN2fd4walk14spawn_receiver28_$u7b$$u7b$closure$u7d$$u7d$28_$u7b$$u7b$closure$u7d$$u7d$17h9100c921955b30a8E") != std::string::npos){ // fd spawn
								IRBuilder<> builder(cal);

								Value* args[] = {
									ConstantInt::get(intTy, -1, false),
									ConstantInt::get(intTy, func_num++, false),
								};
								builder.CreateCall(p_probe_spawned, args);
								errs() << "added call main-------------------------------------------------------------------------------------------------------------------------------\n";
							}
							else if(funcName.find("_ZN2fd4walk14spawn_receiver28_$u7b$$u7b$closure$u7d$$u7d$17h953a9ddec09dc92cE") != std::string::npos){ // fd spawn
								IRBuilder<> builder(cal);

								Value* args[] = {
									ConstantInt::get(intTy, -1, false),
									ConstantInt::get(intTy, func_num++, false),
								};
								builder.CreateCall(p_probe_spawned, args);
								errs() << "added call main-------------------------------------------------------------------------------------------------------------------------------\n";
							}
							else if(funcName.find("_ZN15crossbeam_utils6thread19ScopedThreadBuilder5spawn") != std::string::npos){ // crossbeam spawn
								IRBuilder<> builder(cal);

								Value* args[] = {
									ConstantInt::get(intTy, -1, false),
									ConstantInt::get(intTy, func_num++, false),
								};
								builder.CreateCall(p_probe_spawned, args);
								errs() << "added call main-------------------------------------------------------------------------------------------------------------------------------\n";
							}
							else if(funcName.find("_ZN3std4sync4mpsc17Receiver$LT$T$GT$4recv") != std::string::npos){//recv
								IRBuilder<> builder(cal);

								int loc = cal->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("recv", ""),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_func, args);
								errs() << "added call recv-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr65drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								IRBuilder<> builder(cal);

								int loc = cal->getDebugLoc().getLine();
								Value * var = cal->getArgOperand(0);

								Value * MutexGuard = builder.CreateLoad(var->getType()->getPointerElementType(), var);
								Value * lockPtr = builder.CreateStructGEP(MutexGuard->getType(), var, 0);
								Value * lock = builder.CreateLoad(lockPtr->getType()->getPointerElementType(), lockPtr);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false), // line number
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("unlock", ""),
									builder.CreateBitCast(lock, ptrTy),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
								errs() << "added call unlock-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
							else if(funcName.find("_ZN4core3ptr115drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
								IRBuilder<> builder(cal);

								int loc = cal->getDebugLoc().getLine();
								Value * var = cal->getArgOperand(0);

								Value * MutexGuard = builder.CreateLoad(var->getType()->getPointerElementType(), var);
								Value * lockPtr = builder.CreateStructGEP(MutexGuard->getType(), var, 0);
								Value * lock = builder.CreateLoad(lockPtr->getType()->getPointerElementType(), lockPtr);

								Value* args[] = {
									ConstantInt::get(intTy, loc, false), // line number
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("unlock", ""),
									builder.CreateBitCast(lock, ptrTy),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
								errs() << "added call unlock-------------------------------------------------------------------------------------------------------------------------------\n";
							} 
						}
					}
					else if(I.getOpcode() == Instruction::Invoke) {
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
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
							} 
							else if(funcName.find("_ZN4core3ptr65drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
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
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
							} 
							else if(funcName.find("_ZN4core3ptr115drop_in_place$LT$std..sync..mutex..MutexGuard") != std::string::npos) { // unlock
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
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_mutex, args);
							} 
							else if(funcName.find("_ZN3std4sync4mpsc15Sender$LT$T$GT$4send") != std::string::npos){ //send
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("send", ""),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_func, args);
							} 
							else if(funcName.find("_ZN3std4sync4mpsc17Receiver$LT$T$GT$4recv") != std::string::npos){//recv
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr("recv", ""),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_func, args);
							} 
							else if(funcName.find("_ZN3std6thread5spawn") != std::string::npos){ //spawn
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_spawning, args);
							} 
							else if(funcName.find("_ZN15crossbeam_utils6thread5Scope5spawn") != std::string::npos){ // crossbeam spawning
								IRBuilder<> builder(inv);

								int loc = inv->getDebugLoc().getLine();

								Value* args[] = {
									ConstantInt::get(intTy, loc, false),
									ConstantInt::get(intTy, func_num++, false),
									builder.CreateGlobalStringPtr(filePath, ""),
								};
								builder.CreateCall(p_probe_spawning, args);
							} 
						}
					} // opcode == Instruction::Invoke 
				}
			}
			ofstream write_func_num;
			write_func_num.open("func_num_tle");
			write_func_num << func_num;
			write_func_num.close();
			return PreservedAnalyses::none();
		}

		// Without isRequired returning true, this pass will be skipped for functions
		// decorated with the optnone LLVM attribute. Note that clang -O0 decorates
		// all functions with optnone.
		static bool isRequired() { return true; }

		void initialization(Function &F) {
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
			p_init = F.getParent()->getOrInsertFunction("_ZN9probe_TLE6_init_17h99e5e0e4b42fb836E", fty);

			vector<Type*> paramTypes = {intTy, intTy, ptrTy, ptrTy, ptrTy};
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_mutex = F.getParent()->getOrInsertFunction("_ZN9probe_TLE13_probe_mutex_17h5ce1ad69b9ff6d64E", fty);

			paramTypes = {intTy, intTy, ptrTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_func = F.getParent()->getOrInsertFunction("_ZN9probe_TLE12_probe_func_17h5c538227e75d5879E", fty);
			
			paramTypes = {intTy, intTy, ptrTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_spawning = F.getParent()->getOrInsertFunction("_ZN9probe_TLE16_probe_spawning_17h3984b93918e248b1E", fty);
			
			paramTypes = {intTy, intTy};		
			fty = FunctionType::get(voidTy, paramTypes, false);
			p_probe_spawned = F.getParent()->getOrInsertFunction("_ZN9probe_TLE15_probe_spawned_17h984760e15d22effbE", fty);

			Function * mainFunc = F.getParent()->getFunction(StringRef("main"));
			if(mainFunc != NULL) {
				IRBuilder<> builder(mainFunc->getEntryBlock().getFirstNonPHI());
				vector<Value *> ArgsV;
				builder.CreateCall(p_init, ArgsV, "");
			}
		}
	}; //TLE_pass

} // namespace

// -----------------------------------------------------------------------------------

llvm::PassPluginLibraryInfo get_custom_pass_PluginInfo() {
	return {
		LLVM_PLUGIN_API_VERSION, "my_pass", LLVM_VERSION_STRING, [](PassBuilder &PB) { 
			PB.registerPipelineParsingCallback( [](StringRef Name, FunctionPassManager &FPM, ArrayRef<PassBuilder::PipelineElement>) { 
				if (Name == "RSE_pass") { 
					FPM.addPass(RSE_pass()); 
					return true; 
				} 
				else if (Name == "TLE_pass"){
					FPM.addPass(TLE_pass());
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
