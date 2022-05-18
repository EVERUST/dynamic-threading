; ModuleID = 'basic_mutex.5ff45470-cgu.0'
source_filename = "basic_mutex.5ff45470-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"core::sync::atomic::AtomicUsize" = type { i64 }
%"std::sys::unix::mutex::Mutex" = type { %"core::cell::UnsafeCell<libc::unix::linux_like::linux::pthread_mutex_t>" }
%"core::cell::UnsafeCell<libc::unix::linux_like::linux::pthread_mutex_t>" = type { %"libc::unix::linux_like::linux::pthread_mutex_t" }
%"libc::unix::linux_like::linux::pthread_mutex_t" = type { [40 x i8] }
%"std::sync::poison::Flag" = type { %"core::sync::atomic::AtomicBool" }
%"core::sync::atomic::AtomicBool" = type { i8 }
%"std::sync::mutex::Mutex<i32>" = type { i64*, %"std::sync::poison::Flag", [3 x i8], i32 }
%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>" = type { i64, [2 x i64] }
%"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Ok" = type { [1 x i8], i8 }
%"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Err" = type { [1 x i8], i8 }
%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Err" = type { [1 x i64], { i64*, i8 } }
%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Ok" = type { [1 x i64], { i64*, i8 } }
%"core::panic::location::Location" = type { { [0 x i8]*, i64 }, i32, i32 }
%"alloc::alloc::Global" = type {}
%"core::fmt::Formatter" = type { { i64, i64 }, { i64, i64 }, { {}*, [3 x i64]* }, i32, i32, i8, [7 x i8] }
%"core::fmt::builders::DebugStruct" = type { %"core::fmt::Formatter"*, i8, i8, [6 x i8] }
%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type { [0 x i8] }

@vtable.0 = private unnamed_addr constant <{ i8*, [16 x i8], i8*, i8*, i8*, [0 x i8] }> <{ i8* bitcast (void (i64**)* @"_ZN4core3ptr85drop_in_place$LT$std..rt..lang_start$LT$$LP$$RP$$GT$..$u7b$$u7b$closure$u7d$$u7d$$GT$17h038bce1dec1881abE" to i8*), [16 x i8] c"\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", i8* bitcast (i32 (i64**)* @"_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h3e2858adb6c77106E" to i8*), i8* bitcast (i32 (i64**)* @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17hbd0ce10a8e8bea68E" to i8*), i8* bitcast (i32 (i64**)* @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17hbd0ce10a8e8bea68E" to i8*), [0 x i8] zeroinitializer }>, align 8
@_ZN3std9panicking11panic_count18GLOBAL_PANIC_COUNT17h9f4123c916e0c58dE = external global %"core::sync::atomic::AtomicUsize"
@alloc39 = private unnamed_addr constant <{ [49 x i8] }> <{ [49 x i8] c"there is no such thing as an acquire/release load" }>, align 1
@alloc45 = private unnamed_addr constant <{ [75 x i8] }> <{ [75 x i8] c"/build/rustc-7HAmMa/rustc-1.57.0+dfsg1+llvm/library/core/src/sync/atomic.rs" }>, align 1
@alloc35 = private unnamed_addr constant <{ i8*, [16 x i8] }> <{ i8* getelementptr inbounds (<{ [75 x i8] }>, <{ [75 x i8] }>* @alloc45, i32 0, i32 0, i32 0), [16 x i8] c"K\00\00\00\00\00\00\00<\09\00\00\17\00\00\00" }>, align 8
@alloc40 = private unnamed_addr constant <{ [40 x i8] }> <{ [40 x i8] c"there is no such thing as a release load" }>, align 1
@alloc38 = private unnamed_addr constant <{ i8*, [16 x i8] }> <{ i8* getelementptr inbounds (<{ [75 x i8] }>, <{ [75 x i8] }>* @alloc45, i32 0, i32 0, i32 0), [16 x i8] c"K\00\00\00\00\00\00\00;\09\00\00\18\00\00\00" }>, align 8
@alloc41 = private unnamed_addr constant <{ [50 x i8] }> <{ [50 x i8] c"there is no such thing as an acquire/release store" }>, align 1
@alloc43 = private unnamed_addr constant <{ i8*, [16 x i8] }> <{ i8* getelementptr inbounds (<{ [75 x i8] }>, <{ [75 x i8] }>* @alloc45, i32 0, i32 0, i32 0), [16 x i8] c"K\00\00\00\00\00\00\00.\09\00\00\17\00\00\00" }>, align 8
@alloc44 = private unnamed_addr constant <{ [42 x i8] }> <{ [42 x i8] c"there is no such thing as an acquire store" }>, align 1
@alloc46 = private unnamed_addr constant <{ i8*, [16 x i8] }> <{ i8* getelementptr inbounds (<{ [75 x i8] }>, <{ [75 x i8] }>* @alloc45, i32 0, i32 0, i32 0), [16 x i8] c"K\00\00\00\00\00\00\00-\09\00\00\18\00\00\00" }>, align 8
@alloc47 = private unnamed_addr constant <{ [43 x i8] }> <{ [43 x i8] c"called `Result::unwrap()` on an `Err` value" }>, align 1
@vtable.1 = private unnamed_addr constant <{ i8*, [16 x i8], i8*, [0 x i8] }> <{ i8* bitcast (void ({ i64*, i8 }*)* @"_ZN4core3ptr98drop_in_place$LT$std..sync..poison..PoisonError$LT$std..sync..mutex..MutexGuard$LT$i32$GT$$GT$$GT$17h06dc98f4b18e6985E" to i8*), [16 x i8] c"\10\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", i8* bitcast (i1 ({ i64*, i8 }*, %"core::fmt::Formatter"*)* @"_ZN76_$LT$std..sync..poison..PoisonError$LT$T$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h2e67c26302a96307E" to i8*), [0 x i8] zeroinitializer }>, align 8
@alloc51 = private unnamed_addr constant <{ [11 x i8] }> <{ [11 x i8] c"PoisonError" }>, align 1
@alloc54 = private unnamed_addr constant <{ [14 x i8] }> <{ [14 x i8] c"basic_mutex.rs" }>, align 1
@alloc53 = private unnamed_addr constant <{ i8*, [16 x i8] }> <{ i8* getelementptr inbounds (<{ [14 x i8] }>, <{ [14 x i8] }>* @alloc54, i32 0, i32 0, i32 0), [16 x i8] c"\0E\00\00\00\00\00\00\00\07\00\00\00#\00\00\00" }>, align 8
@alloc55 = private unnamed_addr constant <{ i8*, [16 x i8] }> <{ i8* getelementptr inbounds (<{ [14 x i8] }>, <{ [14 x i8] }>* @alloc54, i32 0, i32 0, i32 0), [16 x i8] c"\0E\00\00\00\00\00\00\00\08\00\00\00%\00\00\00" }>, align 8

; <core::ptr::non_null::NonNull<T> as core::convert::From<core::ptr::unique::Unique<T>>>::from
; Function Attrs: inlinehint nonlazybind uwtable
define internal nonnull i8* @"_ZN119_$LT$core..ptr..non_null..NonNull$LT$T$GT$$u20$as$u20$core..convert..From$LT$core..ptr..unique..Unique$LT$T$GT$$GT$$GT$4from17h1e495aba80809d0fE"(i8* nonnull %unique) unnamed_addr #0 {
start:
; call core::ptr::unique::Unique<T>::as_ptr
  %_2 = call i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17ha1e3e513bb4d99a1E"(i8* nonnull %unique)
  br label %bb1

bb1:                                              ; preds = %start
; call core::ptr::non_null::NonNull<T>::new_unchecked
  %0 = call nonnull i8* @"_ZN4core3ptr8non_null16NonNull$LT$T$GT$13new_unchecked17h09b145925866306eE"(i8* %_2)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i8* %0
}

; std::sys_common::mutex::MovableMutex::raw_unlock
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN3std10sys_common5mutex12MovableMutex10raw_unlock17h37853ab4402fe44aE(i64** align 8 dereferenceable(8) %self) unnamed_addr #0 {
start:
  %0 = bitcast i64** %self to %"std::sys::unix::mutex::Mutex"**
  %_2 = load %"std::sys::unix::mutex::Mutex"*, %"std::sys::unix::mutex::Mutex"** %0, align 8, !nonnull !3
; call std::sys::unix::mutex::Mutex::unlock
  call void @_ZN3std3sys4unix5mutex5Mutex6unlock17h26d55aaa63be3061E(%"std::sys::unix::mutex::Mutex"* align 8 dereferenceable(40) %_2)
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; std::sys_common::mutex::MovableMutex::raw_lock
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN3std10sys_common5mutex12MovableMutex8raw_lock17ha9ae4679297deaafE(i64** align 8 dereferenceable(8) %self) unnamed_addr #0 {
start:
  %0 = bitcast i64** %self to %"std::sys::unix::mutex::Mutex"**
  %_2 = load %"std::sys::unix::mutex::Mutex"*, %"std::sys::unix::mutex::Mutex"** %0, align 8, !nonnull !3
; call std::sys::unix::mutex::Mutex::lock
  call void @_ZN3std3sys4unix5mutex5Mutex4lock17h44c28f1fc99b71acE(%"std::sys::unix::mutex::Mutex"* align 8 dereferenceable(40) %_2)
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; std::sys_common::backtrace::__rust_begin_short_backtrace
; Function Attrs: noinline nonlazybind uwtable
define internal void @_ZN3std10sys_common9backtrace28__rust_begin_short_backtrace17hbe6b9974dbada9dfE(void ()* nonnull %f) unnamed_addr #1 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
start:
  %0 = alloca { i8*, i32 }, align 8
; call core::ops::function::FnOnce::call_once
  call void @_ZN4core3ops8function6FnOnce9call_once17h23f954d2111d1f06E(void ()* nonnull %f)
  br label %bb1

bb1:                                              ; preds = %start
; invoke core::hint::black_box
  invoke void @_ZN4core4hint9black_box17hb3e182cb07835373E()
          to label %bb2 unwind label %cleanup

bb2:                                              ; preds = %bb1
  ret void

bb3:                                              ; preds = %cleanup
  br label %bb4

cleanup:                                          ; preds = %bb1
  %1 = landingpad { i8*, i32 }
          cleanup
  %2 = extractvalue { i8*, i32 } %1, 0
  %3 = extractvalue { i8*, i32 } %1, 1
  %4 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %0, i32 0, i32 0
  store i8* %2, i8** %4, align 8
  %5 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %0, i32 0, i32 1
  store i32 %3, i32* %5, align 8
  br label %bb3

bb4:                                              ; preds = %bb3
  %6 = bitcast { i8*, i32 }* %0 to i8**
  %7 = load i8*, i8** %6, align 8
  %8 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %0, i32 0, i32 1
  %9 = load i32, i32* %8, align 8
  %10 = insertvalue { i8*, i32 } undef, i8* %7, 0
  %11 = insertvalue { i8*, i32 } %10, i32 %9, 1
  resume { i8*, i32 } %11
}

; std::rt::lang_start
; Function Attrs: nonlazybind uwtable
define hidden i64 @_ZN3std2rt10lang_start17he7e40ff57a395f8aE(void ()* nonnull %main, i64 %argc, i8** %argv) unnamed_addr #2 {
start:
  %_8 = alloca i64*, align 8
  %_4 = alloca i64, align 8
  %0 = bitcast i64** %_8 to void ()**
  store void ()* %main, void ()** %0, align 8
  %_5.0 = bitcast i64** %_8 to {}*
; call std::rt::lang_start_internal
  %1 = call i64 @_ZN3std2rt19lang_start_internal17h64a8327b226752c1E({}* nonnull align 1 %_5.0, [3 x i64]* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8], i8*, i8*, i8*, [0 x i8] }>* @vtable.0 to [3 x i64]*), i64 %argc, i8** %argv)
  store i64 %1, i64* %_4, align 8
  br label %bb1

bb1:                                              ; preds = %start
  %v = load i64, i64* %_4, align 8
  ret i64 %v
}

; std::rt::lang_start::{{closure}}
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17hbd0ce10a8e8bea68E"(i64** align 8 dereferenceable(8) %_1) unnamed_addr #0 {
start:
  %0 = bitcast i64** %_1 to void ()**
  %_3 = load void ()*, void ()** %0, align 8, !nonnull !3
; call std::sys_common::backtrace::__rust_begin_short_backtrace
  call void @_ZN3std10sys_common9backtrace28__rust_begin_short_backtrace17hbe6b9974dbada9dfE(void ()* nonnull %_3)
  br label %bb1

bb1:                                              ; preds = %start
; call <() as std::process::Termination>::report
  %1 = call i32 @"_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17ha5c4d5e9d1a21070E"()
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i32 %1
}

; std::sys::unix::mutex::Mutex::lock
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN3std3sys4unix5mutex5Mutex4lock17h44c28f1fc99b71acE(%"std::sys::unix::mutex::Mutex"* align 8 dereferenceable(40) %self) unnamed_addr #0 {
start:
  %_4 = bitcast %"std::sys::unix::mutex::Mutex"* %self to %"core::cell::UnsafeCell<libc::unix::linux_like::linux::pthread_mutex_t>"*
  %_2.i = bitcast %"core::cell::UnsafeCell<libc::unix::linux_like::linux::pthread_mutex_t>"* %_4 to %"libc::unix::linux_like::linux::pthread_mutex_t"*
  br label %bb1

bb1:                                              ; preds = %start
  %r = call i32 @pthread_mutex_lock(%"libc::unix::linux_like::linux::pthread_mutex_t"* %_2.i)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret void
}

; std::sys::unix::mutex::Mutex::unlock
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN3std3sys4unix5mutex5Mutex6unlock17h26d55aaa63be3061E(%"std::sys::unix::mutex::Mutex"* align 8 dereferenceable(40) %self) unnamed_addr #0 {
start:
  %_4 = bitcast %"std::sys::unix::mutex::Mutex"* %self to %"core::cell::UnsafeCell<libc::unix::linux_like::linux::pthread_mutex_t>"*
  %_2.i = bitcast %"core::cell::UnsafeCell<libc::unix::linux_like::linux::pthread_mutex_t>"* %_4 to %"libc::unix::linux_like::linux::pthread_mutex_t"*
  br label %bb1

bb1:                                              ; preds = %start
  %r = call i32 @pthread_mutex_unlock(%"libc::unix::linux_like::linux::pthread_mutex_t"* %_2.i)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret void
}

; std::sys::unix::process::process_common::ExitCode::as_i32
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @_ZN3std3sys4unix7process14process_common8ExitCode6as_i3217h79ec5038914b13e4E(i8* align 1 dereferenceable(1) %self) unnamed_addr #0 {
start:
  %_2 = load i8, i8* %self, align 1
  %0 = zext i8 %_2 to i32
  ret i32 %0
}

; std::sync::mutex::Mutex<T>::new
; Function Attrs: nonlazybind uwtable
define internal i128 @"_ZN3std4sync5mutex14Mutex$LT$T$GT$3new17h95c9d75482b740b2E"(i32 %t) unnamed_addr #2 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
start:
  %0 = alloca i32, align 4
  %1 = alloca i8, align 1
  %2 = alloca { i8*, i32 }, align 8
  %_6 = alloca i8, align 1
  %_3 = alloca %"std::sync::poison::Flag", align 1
  %_2 = alloca i64*, align 8
  %3 = alloca %"std::sync::mutex::Mutex<i32>", align 8
  store i8 0, i8* %_6, align 1
  store i8 1, i8* %_6, align 1
; invoke std::sys_common::mutex::MovableMutex::new
  %4 = invoke noalias nonnull align 8 i64* @_ZN3std10sys_common5mutex12MovableMutex3new17h2bb8f0e9b979bf81E()
          to label %bb1 unwind label %cleanup

bb1:                                              ; preds = %start
  store i64* %4, i64** %_2, align 8
; invoke std::sync::poison::Flag::new
  %5 = invoke i8 @_ZN3std4sync6poison4Flag3new17h47827b134c610a5eE()
          to label %bb2 unwind label %cleanup1

bb7:                                              ; preds = %bb4, %cleanup
  %6 = load i8, i8* %_6, align 1, !range !4
  %7 = trunc i8 %6 to i1
  br i1 %7, label %bb6, label %bb5

cleanup:                                          ; preds = %start
  %8 = landingpad { i8*, i32 }
          cleanup
  %9 = extractvalue { i8*, i32 } %8, 0
  %10 = extractvalue { i8*, i32 } %8, 1
  %11 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %2, i32 0, i32 0
  store i8* %9, i8** %11, align 8
  %12 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %2, i32 0, i32 1
  store i32 %10, i32* %12, align 8
  br label %bb7

bb2:                                              ; preds = %bb1
  store i8 %5, i8* %1, align 1
  %13 = bitcast %"std::sync::poison::Flag"* %_3 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %13, i8* align 1 %1, i64 1, i1 false)
  store i8 0, i8* %_6, align 1
  store i32 %t, i32* %0, align 4
  %14 = load i32, i32* %0, align 4
  br label %bb3

bb4:                                              ; preds = %cleanup1
; call core::ptr::drop_in_place<std::sys_common::mutex::MovableMutex>
  call void @"_ZN4core3ptr57drop_in_place$LT$std..sys_common..mutex..MovableMutex$GT$17ha287985150b8ad91E"(i64** %_2) #9
  br label %bb7

cleanup1:                                         ; preds = %bb1
  %15 = landingpad { i8*, i32 }
          cleanup
  %16 = extractvalue { i8*, i32 } %15, 0
  %17 = extractvalue { i8*, i32 } %15, 1
  %18 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %2, i32 0, i32 0
  store i8* %16, i8** %18, align 8
  %19 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %2, i32 0, i32 1
  store i32 %17, i32* %19, align 8
  br label %bb4

bb3:                                              ; preds = %bb2
  %20 = bitcast %"std::sync::mutex::Mutex<i32>"* %3 to i64**
  %21 = load i64*, i64** %_2, align 8, !nonnull !3
  store i64* %21, i64** %20, align 8
  %22 = getelementptr inbounds %"std::sync::mutex::Mutex<i32>", %"std::sync::mutex::Mutex<i32>"* %3, i32 0, i32 1
  %23 = bitcast %"std::sync::poison::Flag"* %22 to i8*
  %24 = bitcast %"std::sync::poison::Flag"* %_3 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %23, i8* align 1 %24, i64 1, i1 false)
  %25 = getelementptr inbounds %"std::sync::mutex::Mutex<i32>", %"std::sync::mutex::Mutex<i32>"* %3, i32 0, i32 3
  store i32 %14, i32* %25, align 4
  %26 = bitcast %"std::sync::mutex::Mutex<i32>"* %3 to i128*
  %27 = load i128, i128* %26, align 8
  ret i128 %27

bb5:                                              ; preds = %bb6, %bb7
  %28 = bitcast { i8*, i32 }* %2 to i8**
  %29 = load i8*, i8** %28, align 8
  %30 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %2, i32 0, i32 1
  %31 = load i32, i32* %30, align 8
  %32 = insertvalue { i8*, i32 } undef, i8* %29, 0
  %33 = insertvalue { i8*, i32 } %32, i32 %31, 1
  resume { i8*, i32 } %33

bb6:                                              ; preds = %bb7
  br label %bb5
}

; std::sync::mutex::Mutex<T>::lock
; Function Attrs: nonlazybind uwtable
define internal void @"_ZN3std4sync5mutex14Mutex$LT$T$GT$4lock17h6ca29baf9cb88884E"(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture sret(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>") dereferenceable(24) %0, %"std::sync::mutex::Mutex<i32>"* align 8 dereferenceable(16) %self) unnamed_addr #2 {
start:
  %_3 = bitcast %"std::sync::mutex::Mutex<i32>"* %self to i64**
; call std::sys_common::mutex::MovableMutex::raw_lock
  call void @_ZN3std10sys_common5mutex12MovableMutex8raw_lock17ha9ae4679297deaafE(i64** align 8 dereferenceable(8) %_3)
  br label %bb1

bb1:                                              ; preds = %start
; call std::sync::mutex::MutexGuard<T>::new
  call void @"_ZN3std4sync5mutex19MutexGuard$LT$T$GT$3new17h1e9c36ee05b68912E"(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture sret(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>") dereferenceable(24) %0, %"std::sync::mutex::Mutex<i32>"* align 8 dereferenceable(16) %self)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret void
}

; std::sync::mutex::MutexGuard<T>::new
; Function Attrs: nonlazybind uwtable
define internal void @"_ZN3std4sync5mutex19MutexGuard$LT$T$GT$3new17h1e9c36ee05b68912E"(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture sret(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>") dereferenceable(24) %0, %"std::sync::mutex::Mutex<i32>"* align 8 dereferenceable(16) %1) unnamed_addr #2 {
start:
  %_4 = alloca i64*, align 8
  %lock = alloca %"std::sync::mutex::Mutex<i32>"*, align 8
  store %"std::sync::mutex::Mutex<i32>"* %1, %"std::sync::mutex::Mutex<i32>"** %lock, align 8
  %2 = load %"std::sync::mutex::Mutex<i32>"*, %"std::sync::mutex::Mutex<i32>"** %lock, align 8, !nonnull !3
  %_3 = getelementptr inbounds %"std::sync::mutex::Mutex<i32>", %"std::sync::mutex::Mutex<i32>"* %2, i32 0, i32 1
; call std::sync::poison::Flag::borrow
  %3 = call { i8, i8 } @_ZN3std4sync6poison4Flag6borrow17h189947d836788645E(%"std::sync::poison::Flag"* align 1 dereferenceable(1) %_3)
  %4 = extractvalue { i8, i8 } %3, 0
  %_2.0 = trunc i8 %4 to i1
  %_2.1 = extractvalue { i8, i8 } %3, 1
  br label %bb1

bb1:                                              ; preds = %start
  %5 = bitcast i64** %_4 to %"std::sync::mutex::Mutex<i32>"***
  store %"std::sync::mutex::Mutex<i32>"** %lock, %"std::sync::mutex::Mutex<i32>"*** %5, align 8
  %6 = load i64*, i64** %_4, align 8, !nonnull !3
; call std::sync::poison::map_result
  call void @_ZN3std4sync6poison10map_result17h33f4157d113d2095E(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture sret(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>") dereferenceable(24) %0, i1 zeroext %_2.0, i8 %_2.1, i64* align 8 dereferenceable(8) %6)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret void
}

; std::sync::mutex::MutexGuard<T>::new::{{closure}}
; Function Attrs: inlinehint nonlazybind uwtable
define internal { i64*, i8 } @"_ZN3std4sync5mutex19MutexGuard$LT$T$GT$3new28_$u7b$$u7b$closure$u7d$$u7d$17h4adc4508499b859aE"(i64* align 8 dereferenceable(8) %_1, i1 zeroext %guard) unnamed_addr #0 {
start:
  %0 = alloca { i64*, i8 }, align 8
  %1 = bitcast i64* %_1 to %"std::sync::mutex::Mutex<i32>"**
  %2 = bitcast i64* %_1 to %"std::sync::mutex::Mutex<i32>"**
  %_3 = load %"std::sync::mutex::Mutex<i32>"*, %"std::sync::mutex::Mutex<i32>"** %2, align 8, !nonnull !3
  %3 = bitcast { i64*, i8 }* %0 to %"std::sync::mutex::Mutex<i32>"**
  store %"std::sync::mutex::Mutex<i32>"* %_3, %"std::sync::mutex::Mutex<i32>"** %3, align 8
  %4 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %0, i32 0, i32 1
  %5 = zext i1 %guard to i8
  store i8 %5, i8* %4, align 8
  %6 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %0, i32 0, i32 0
  %7 = load i64*, i64** %6, align 8, !nonnull !3
  %8 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %0, i32 0, i32 1
  %9 = load i8, i8* %8, align 8, !range !4
  %10 = trunc i8 %9 to i1
  %11 = zext i1 %10 to i8
  %12 = insertvalue { i64*, i8 } undef, i64* %7, 0
  %13 = insertvalue { i64*, i8 } %12, i8 %11, 1
  ret { i64*, i8 } %13
}

; std::sync::poison::map_result
; Function Attrs: nonlazybind uwtable
define internal void @_ZN3std4sync6poison10map_result17h33f4157d113d2095E(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture sret(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>") dereferenceable(24) %0, i1 zeroext %1, i8 %2, i64* align 8 dereferenceable(8) %f) unnamed_addr #2 {
start:
  %_13 = alloca i8, align 1
  %_7 = alloca i8, align 1
  %result = alloca { i8, i8 }, align 1
  %3 = getelementptr inbounds { i8, i8 }, { i8, i8 }* %result, i32 0, i32 0
  %4 = zext i1 %1 to i8
  store i8 %4, i8* %3, align 1
  %5 = getelementptr inbounds { i8, i8 }, { i8, i8 }* %result, i32 0, i32 1
  store i8 %2, i8* %5, align 1
  %6 = bitcast { i8, i8 }* %result to i8*
  %7 = load i8, i8* %6, align 1, !range !4
  %8 = trunc i8 %7 to i1
  %_3 = zext i1 %8 to i64
  switch i64 %_3, label %bb2 [
    i64 0, label %bb3
    i64 1, label %bb1
  ]

bb2:                                              ; preds = %start
  unreachable

bb3:                                              ; preds = %start
  %9 = bitcast { i8, i8 }* %result to %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Ok"*
  %10 = getelementptr inbounds %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Ok", %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Ok"* %9, i32 0, i32 1
  %11 = load i8, i8* %10, align 1, !range !4
  %t = trunc i8 %11 to i1
  %12 = zext i1 %t to i8
  store i8 %12, i8* %_7, align 1
  %13 = load i8, i8* %_7, align 1, !range !4
  %14 = trunc i8 %13 to i1
; call std::sync::mutex::MutexGuard<T>::new::{{closure}}
  %15 = call { i64*, i8 } @"_ZN3std4sync5mutex19MutexGuard$LT$T$GT$3new28_$u7b$$u7b$closure$u7d$$u7d$17h4adc4508499b859aE"(i64* align 8 dereferenceable(8) %f, i1 zeroext %14)
  %_5.0 = extractvalue { i64*, i8 } %15, 0
  %16 = extractvalue { i64*, i8 } %15, 1
  %_5.1 = trunc i8 %16 to i1
  br label %bb4

bb1:                                              ; preds = %start
  %17 = bitcast { i8, i8 }* %result to %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Err"*
  %18 = getelementptr inbounds %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Err", %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Err"* %17, i32 0, i32 1
  %19 = load i8, i8* %18, align 1, !range !4
  %guard = trunc i8 %19 to i1
  %20 = zext i1 %guard to i8
  store i8 %20, i8* %_13, align 1
  %21 = load i8, i8* %_13, align 1, !range !4
  %22 = trunc i8 %21 to i1
; call std::sync::mutex::MutexGuard<T>::new::{{closure}}
  %23 = call { i64*, i8 } @"_ZN3std4sync5mutex19MutexGuard$LT$T$GT$3new28_$u7b$$u7b$closure$u7d$$u7d$17h4adc4508499b859aE"(i64* align 8 dereferenceable(8) %f, i1 zeroext %22)
  %_11.0 = extractvalue { i64*, i8 } %23, 0
  %24 = extractvalue { i64*, i8 } %23, 1
  %_11.1 = trunc i8 %24 to i1
  br label %bb5

bb5:                                              ; preds = %bb1
; call std::sync::poison::PoisonError<T>::new
  %25 = call { i64*, i8 } @"_ZN3std4sync6poison20PoisonError$LT$T$GT$3new17h44e581ee7a3aa034E"(i64* align 8 dereferenceable(16) %_11.0, i1 zeroext %_11.1)
  %_10.0 = extractvalue { i64*, i8 } %25, 0
  %26 = extractvalue { i64*, i8 } %25, 1
  %_10.1 = trunc i8 %26 to i1
  br label %bb6

bb6:                                              ; preds = %bb5
  %27 = bitcast %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* %0 to %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Err"*
  %28 = getelementptr inbounds %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Err", %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Err"* %27, i32 0, i32 1
  %29 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %28, i32 0, i32 0
  store i64* %_10.0, i64** %29, align 8
  %30 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %28, i32 0, i32 1
  %31 = zext i1 %_10.1 to i8
  store i8 %31, i8* %30, align 8
  %32 = bitcast %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* %0 to i64*
  store i64 1, i64* %32, align 8
  br label %bb7

bb7:                                              ; preds = %bb4, %bb6
  %33 = bitcast { i8, i8 }* %result to i8*
  %34 = load i8, i8* %33, align 1, !range !4
  %35 = trunc i8 %34 to i1
  %_15 = zext i1 %35 to i64
  %36 = icmp eq i64 %_15, 0
  br i1 %36, label %bb8, label %bb9

bb4:                                              ; preds = %bb3
  %37 = bitcast %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* %0 to %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Ok"*
  %38 = getelementptr inbounds %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Ok", %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Ok"* %37, i32 0, i32 1
  %39 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %38, i32 0, i32 0
  store i64* %_5.0, i64** %39, align 8
  %40 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %38, i32 0, i32 1
  %41 = zext i1 %_5.1 to i8
  store i8 %41, i8* %40, align 8
  %42 = bitcast %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* %0 to i64*
  store i64 0, i64* %42, align 8
  br label %bb7

bb8:                                              ; preds = %bb9, %bb7
  ret void

bb9:                                              ; preds = %bb7
  br label %bb8
}

; std::sync::poison::PoisonError<T>::new
; Function Attrs: nonlazybind uwtable
define internal zeroext i1 @"_ZN3std4sync6poison20PoisonError$LT$T$GT$3new17h3fdadffbce9cf23cE"(i1 zeroext %guard) unnamed_addr #2 {
start:
  %0 = alloca i8, align 1
  %1 = zext i1 %guard to i8
  store i8 %1, i8* %0, align 1
  %2 = load i8, i8* %0, align 1, !range !4
  %3 = trunc i8 %2 to i1
  ret i1 %3
}

; std::sync::poison::PoisonError<T>::new
; Function Attrs: nonlazybind uwtable
define internal { i64*, i8 } @"_ZN3std4sync6poison20PoisonError$LT$T$GT$3new17h44e581ee7a3aa034E"(i64* align 8 dereferenceable(16) %guard.0, i1 zeroext %guard.1) unnamed_addr #2 {
start:
  %0 = alloca { i64*, i8 }, align 8
  %1 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %0, i32 0, i32 0
  store i64* %guard.0, i64** %1, align 8
  %2 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %0, i32 0, i32 1
  %3 = zext i1 %guard.1 to i8
  store i8 %3, i8* %2, align 8
  %4 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %0, i32 0, i32 0
  %5 = load i64*, i64** %4, align 8, !nonnull !3
  %6 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %0, i32 0, i32 1
  %7 = load i8, i8* %6, align 8, !range !4
  %8 = trunc i8 %7 to i1
  %9 = zext i1 %8 to i8
  %10 = insertvalue { i64*, i8 } undef, i64* %5, 0
  %11 = insertvalue { i64*, i8 } %10, i8 %9, 1
  ret { i64*, i8 } %11
}

; std::sync::poison::Flag::get
; Function Attrs: inlinehint nonlazybind uwtable
define internal zeroext i1 @_ZN3std4sync6poison4Flag3get17h5df2045c61042629E(%"std::sync::poison::Flag"* align 1 dereferenceable(1) %self) unnamed_addr #0 {
start:
  %_3 = alloca i8, align 1
  %_2 = bitcast %"std::sync::poison::Flag"* %self to %"core::sync::atomic::AtomicBool"*
  store i8 0, i8* %_3, align 1
  %0 = load i8, i8* %_3, align 1, !range !5
; call core::sync::atomic::AtomicBool::load
  %1 = call zeroext i1 @_ZN4core4sync6atomic10AtomicBool4load17h535649c9d727243eE(%"core::sync::atomic::AtomicBool"* align 1 dereferenceable(1) %_2, i8 %0)
  br label %bb1

bb1:                                              ; preds = %start
  ret i1 %1
}

; std::sync::poison::Flag::done
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN3std4sync6poison4Flag4done17hc0a8dd141c4055f4E(%"std::sync::poison::Flag"* align 1 dereferenceable(1) %self, i8* align 1 dereferenceable(1) %guard) unnamed_addr #0 {
start:
  %_9 = alloca i8, align 1
  %_3 = alloca i8, align 1
  %0 = load i8, i8* %guard, align 1, !range !4
  %_5 = trunc i8 %0 to i1
  %_4 = xor i1 %_5, true
  br i1 %_4, label %bb2, label %bb1

bb1:                                              ; preds = %start
  store i8 0, i8* %_3, align 1
  br label %bb3

bb2:                                              ; preds = %start
; call std::thread::panicking
  %_6 = call zeroext i1 @_ZN3std6thread9panicking17h940f1012ee4c40c1E()
  br label %bb4

bb4:                                              ; preds = %bb2
  %1 = zext i1 %_6 to i8
  store i8 %1, i8* %_3, align 1
  br label %bb3

bb3:                                              ; preds = %bb1, %bb4
  %2 = load i8, i8* %_3, align 1, !range !4
  %3 = trunc i8 %2 to i1
  br i1 %3, label %bb5, label %bb7

bb7:                                              ; preds = %bb6, %bb3
  ret void

bb5:                                              ; preds = %bb3
  %_8 = bitcast %"std::sync::poison::Flag"* %self to %"core::sync::atomic::AtomicBool"*
  store i8 0, i8* %_9, align 1
  %4 = load i8, i8* %_9, align 1, !range !5
; call core::sync::atomic::AtomicBool::store
  call void @_ZN4core4sync6atomic10AtomicBool5store17hf7a5813169a62980E(%"core::sync::atomic::AtomicBool"* align 1 dereferenceable(1) %_8, i1 zeroext true, i8 %4)
  br label %bb6

bb6:                                              ; preds = %bb5
  br label %bb7
}

; std::sync::poison::Flag::borrow
; Function Attrs: inlinehint nonlazybind uwtable
define internal { i8, i8 } @_ZN3std4sync6poison4Flag6borrow17h189947d836788645E(%"std::sync::poison::Flag"* align 1 dereferenceable(1) %self) unnamed_addr #0 {
start:
  %ret = alloca i8, align 1
  %0 = alloca { i8, i8 }, align 1
; call std::thread::panicking
  %_3 = call zeroext i1 @_ZN3std6thread9panicking17h940f1012ee4c40c1E()
  br label %bb1

bb1:                                              ; preds = %start
  %1 = zext i1 %_3 to i8
  store i8 %1, i8* %ret, align 1
; call std::sync::poison::Flag::get
  %_4 = call zeroext i1 @_ZN3std4sync6poison4Flag3get17h5df2045c61042629E(%"std::sync::poison::Flag"* align 1 dereferenceable(1) %self)
  br label %bb2

bb2:                                              ; preds = %bb1
  br i1 %_4, label %bb3, label %bb5

bb5:                                              ; preds = %bb2
  %2 = load i8, i8* %ret, align 1, !range !4
  %_8 = trunc i8 %2 to i1
  %3 = bitcast { i8, i8 }* %0 to %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Ok"*
  %4 = getelementptr inbounds %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Ok", %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Ok"* %3, i32 0, i32 1
  %5 = zext i1 %_8 to i8
  store i8 %5, i8* %4, align 1
  %6 = bitcast { i8, i8 }* %0 to i8*
  store i8 0, i8* %6, align 1
  br label %bb6

bb3:                                              ; preds = %bb2
  %7 = load i8, i8* %ret, align 1, !range !4
  %_7 = trunc i8 %7 to i1
; call std::sync::poison::PoisonError<T>::new
  %_6 = call zeroext i1 @"_ZN3std4sync6poison20PoisonError$LT$T$GT$3new17h3fdadffbce9cf23cE"(i1 zeroext %_7)
  br label %bb4

bb4:                                              ; preds = %bb3
  %8 = bitcast { i8, i8 }* %0 to %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Err"*
  %9 = getelementptr inbounds %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Err", %"core::result::Result<std::sync::poison::Guard, std::sync::poison::PoisonError<std::sync::poison::Guard>>::Err"* %8, i32 0, i32 1
  %10 = zext i1 %_6 to i8
  store i8 %10, i8* %9, align 1
  %11 = bitcast { i8, i8 }* %0 to i8*
  store i8 1, i8* %11, align 1
  br label %bb6

bb6:                                              ; preds = %bb5, %bb4
  %12 = getelementptr inbounds { i8, i8 }, { i8, i8 }* %0, i32 0, i32 0
  %13 = load i8, i8* %12, align 1, !range !4
  %14 = trunc i8 %13 to i1
  %15 = getelementptr inbounds { i8, i8 }, { i8, i8 }* %0, i32 0, i32 1
  %16 = load i8, i8* %15, align 1
  %17 = zext i1 %14 to i8
  %18 = insertvalue { i8, i8 } undef, i8 %17, 0
  %19 = insertvalue { i8, i8 } %18, i8 %16, 1
  ret { i8, i8 } %19
}

; std::thread::panicking
; Function Attrs: inlinehint nonlazybind uwtable
define internal zeroext i1 @_ZN3std6thread9panicking17h940f1012ee4c40c1E() unnamed_addr #0 {
start:
; call std::panicking::panicking
  %0 = call zeroext i1 @_ZN3std9panicking9panicking17h24a75f73950f2813E()
  br label %bb1

bb1:                                              ; preds = %start
  ret i1 %0
}

; std::panicking::panic_count::count_is_zero
; Function Attrs: inlinehint nonlazybind uwtable
define internal zeroext i1 @_ZN3std9panicking11panic_count13count_is_zero17h700f1d9483e95353E() unnamed_addr #0 {
start:
  %_5 = alloca i8, align 1
  %0 = alloca i8, align 1
  store i8 0, i8* %_5, align 1
  %1 = load i8, i8* %_5, align 1, !range !5
; call core::sync::atomic::AtomicUsize::load
  %_2 = call i64 @_ZN4core4sync6atomic11AtomicUsize4load17hcffc57f1db02f0d1E(%"core::sync::atomic::AtomicUsize"* align 8 dereferenceable(8) @_ZN3std9panicking11panic_count18GLOBAL_PANIC_COUNT17h9f4123c916e0c58dE, i8 %1)
  br label %bb1

bb1:                                              ; preds = %start
  %_1 = and i64 %_2, 9223372036854775807
  %2 = icmp eq i64 %_1, 0
  br i1 %2, label %bb2, label %bb3

bb2:                                              ; preds = %bb1
  store i8 1, i8* %0, align 1
  br label %bb4

bb3:                                              ; preds = %bb1
; call std::panicking::panic_count::is_zero_slow_path
  %3 = call zeroext i1 @_ZN3std9panicking11panic_count17is_zero_slow_path17h88139735fad522c1E()
  %4 = zext i1 %3 to i8
  store i8 %4, i8* %0, align 1
  br label %bb4

bb4:                                              ; preds = %bb2, %bb3
  %5 = load i8, i8* %0, align 1, !range !4
  %6 = trunc i8 %5 to i1
  ret i1 %6
}

; std::panicking::panicking
; Function Attrs: inlinehint nonlazybind uwtable
define internal zeroext i1 @_ZN3std9panicking9panicking17h24a75f73950f2813E() unnamed_addr #0 {
start:
; call std::panicking::panic_count::count_is_zero
  %_1 = call zeroext i1 @_ZN3std9panicking11panic_count13count_is_zero17h700f1d9483e95353E()
  br label %bb1

bb1:                                              ; preds = %start
  %0 = xor i1 %_1, true
  ret i1 %0
}

; core::num::nonzero::NonZeroUsize::new_unchecked
; Function Attrs: inlinehint nonlazybind uwtable
define internal i64 @_ZN4core3num7nonzero12NonZeroUsize13new_unchecked17h1b2b7bcf93a2a667E(i64 %n) unnamed_addr #0 {
start:
  %0 = alloca i64, align 8
  store i64 %n, i64* %0, align 8
  %1 = load i64, i64* %0, align 8, !range !6
  ret i64 %1
}

; core::num::nonzero::NonZeroUsize::get
; Function Attrs: inlinehint nonlazybind uwtable
define internal i64 @_ZN4core3num7nonzero12NonZeroUsize3get17h7fc5b9bc625db361E(i64 %self) unnamed_addr #0 {
start:
  ret i64 %self
}

; core::ops::function::FnOnce::call_once{{vtable.shim}}
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @"_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h3e2858adb6c77106E"(i64** %_1) unnamed_addr #0 {
start:
  %_2 = alloca {}, align 1
  %0 = load i64*, i64** %_1, align 8, !nonnull !3
; call core::ops::function::FnOnce::call_once
  %1 = call i32 @_ZN4core3ops8function6FnOnce9call_once17h2e872868141861c9E(i64* nonnull %0)
  br label %bb1

bb1:                                              ; preds = %start
  ret i32 %1
}

; core::ops::function::FnOnce::call_once
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN4core3ops8function6FnOnce9call_once17h23f954d2111d1f06E(void ()* nonnull %_1) unnamed_addr #0 {
start:
  %_2 = alloca {}, align 1
  call void %_1()
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; core::ops::function::FnOnce::call_once
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @_ZN4core3ops8function6FnOnce9call_once17h2e872868141861c9E(i64* nonnull %0) unnamed_addr #0 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
start:
  %1 = alloca { i8*, i32 }, align 8
  %_2 = alloca {}, align 1
  %_1 = alloca i64*, align 8
  store i64* %0, i64** %_1, align 8
; invoke std::rt::lang_start::{{closure}}
  %2 = invoke i32 @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17hbd0ce10a8e8bea68E"(i64** align 8 dereferenceable(8) %_1)
          to label %bb1 unwind label %cleanup

bb1:                                              ; preds = %start
  br label %bb2

bb3:                                              ; preds = %cleanup
  br label %bb4

cleanup:                                          ; preds = %start
  %3 = landingpad { i8*, i32 }
          cleanup
  %4 = extractvalue { i8*, i32 } %3, 0
  %5 = extractvalue { i8*, i32 } %3, 1
  %6 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 0
  store i8* %4, i8** %6, align 8
  %7 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 1
  store i32 %5, i32* %7, align 8
  br label %bb3

bb4:                                              ; preds = %bb3
  %8 = bitcast { i8*, i32 }* %1 to i8**
  %9 = load i8*, i8** %8, align 8
  %10 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 1
  %11 = load i32, i32* %10, align 8
  %12 = insertvalue { i8*, i32 } undef, i8* %9, 0
  %13 = insertvalue { i8*, i32 } %12, i32 %11, 1
  resume { i8*, i32 } %13

bb2:                                              ; preds = %bb1
  ret i32 %2
}

; core::ptr::drop_in_place<std::sync::mutex::Mutex<i32>>
; Function Attrs: nonlazybind uwtable
define internal void @"_ZN4core3ptr55drop_in_place$LT$std..sync..mutex..Mutex$LT$i32$GT$$GT$17h92fac7aa3e213bd1E"(%"std::sync::mutex::Mutex<i32>"* %_1) unnamed_addr #2 {
start:
  %0 = bitcast %"std::sync::mutex::Mutex<i32>"* %_1 to i64**
; call core::ptr::drop_in_place<std::sys_common::mutex::MovableMutex>
  call void @"_ZN4core3ptr57drop_in_place$LT$std..sys_common..mutex..MovableMutex$GT$17ha287985150b8ad91E"(i64** %0)
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; core::ptr::drop_in_place<std::sys_common::mutex::MovableMutex>
; Function Attrs: nonlazybind uwtable
define internal void @"_ZN4core3ptr57drop_in_place$LT$std..sys_common..mutex..MovableMutex$GT$17ha287985150b8ad91E"(i64** %_1) unnamed_addr #2 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
start:
  %0 = alloca { i8*, i32 }, align 8
; invoke <std::sys_common::mutex::MovableMutex as core::ops::drop::Drop>::drop
  invoke void @"_ZN78_$LT$std..sys_common..mutex..MovableMutex$u20$as$u20$core..ops..drop..Drop$GT$4drop17ha55fce36199af4d5E"(i64** align 8 dereferenceable(8) %_1)
          to label %bb4 unwind label %cleanup

bb4:                                              ; preds = %start
  %1 = bitcast i64** %_1 to %"std::sys::unix::mutex::Mutex"**
; call core::ptr::drop_in_place<alloc::boxed::Box<std::sys::unix::mutex::Mutex>>
  call void @"_ZN4core3ptr74drop_in_place$LT$alloc..boxed..Box$LT$std..sys..unix..mutex..Mutex$GT$$GT$17h189e3a679bb4808aE"(%"std::sys::unix::mutex::Mutex"** %1)
  br label %bb2

bb3:                                              ; preds = %cleanup
  %2 = bitcast i64** %_1 to %"std::sys::unix::mutex::Mutex"**
; call core::ptr::drop_in_place<alloc::boxed::Box<std::sys::unix::mutex::Mutex>>
  call void @"_ZN4core3ptr74drop_in_place$LT$alloc..boxed..Box$LT$std..sys..unix..mutex..Mutex$GT$$GT$17h189e3a679bb4808aE"(%"std::sys::unix::mutex::Mutex"** %2) #9
  br label %bb1

cleanup:                                          ; preds = %start
  %3 = landingpad { i8*, i32 }
          cleanup
  %4 = extractvalue { i8*, i32 } %3, 0
  %5 = extractvalue { i8*, i32 } %3, 1
  %6 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %0, i32 0, i32 0
  store i8* %4, i8** %6, align 8
  %7 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %0, i32 0, i32 1
  store i32 %5, i32* %7, align 8
  br label %bb3

bb1:                                              ; preds = %bb3
  %8 = bitcast { i8*, i32 }* %0 to i8**
  %9 = load i8*, i8** %8, align 8
  %10 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %0, i32 0, i32 1
  %11 = load i32, i32* %10, align 8
  %12 = insertvalue { i8*, i32 } undef, i8* %9, 0
  %13 = insertvalue { i8*, i32 } %12, i32 %11, 1
  resume { i8*, i32 } %13

bb2:                                              ; preds = %bb4
  ret void
}

; core::ptr::drop_in_place<std::sync::mutex::MutexGuard<i32>>
; Function Attrs: nonlazybind uwtable
define internal void @"_ZN4core3ptr60drop_in_place$LT$std..sync..mutex..MutexGuard$LT$i32$GT$$GT$17hfdb344ac9615acc8E"({ i64*, i8 }* %_1) unnamed_addr #2 {
start:
; call <std::sync::mutex::MutexGuard<T> as core::ops::drop::Drop>::drop
  call void @"_ZN79_$LT$std..sync..mutex..MutexGuard$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he6ee18b679d50667E"({ i64*, i8 }* align 8 dereferenceable(16) %_1)
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; core::ptr::unique::Unique<T>::new_unchecked
; Function Attrs: inlinehint nonlazybind uwtable
define internal nonnull i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$13new_unchecked17h34ce04f649d65bd0E"(i8* %ptr) unnamed_addr #0 {
start:
  %0 = alloca i8*, align 8
  store i8* %ptr, i8** %0, align 8
  %1 = load i8*, i8** %0, align 8, !nonnull !3
  ret i8* %1
}

; core::ptr::unique::Unique<T>::cast
; Function Attrs: inlinehint nonlazybind uwtable
define internal nonnull i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$4cast17hfbf6cb66d2d175ceE"(i64* nonnull %self) unnamed_addr #0 {
start:
; call core::ptr::unique::Unique<T>::as_ptr
  %_3 = call %"std::sys::unix::mutex::Mutex"* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17ha988ebfa6381cd4cE"(i64* nonnull %self)
  br label %bb1

bb1:                                              ; preds = %start
  %_2 = bitcast %"std::sys::unix::mutex::Mutex"* %_3 to i8*
; call core::ptr::unique::Unique<T>::new_unchecked
  %0 = call nonnull i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$13new_unchecked17h34ce04f649d65bd0E"(i8* %_2)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i8* %0
}

; core::ptr::unique::Unique<T>::as_ptr
; Function Attrs: inlinehint nonlazybind uwtable
define internal i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17ha1e3e513bb4d99a1E"(i8* nonnull %self) unnamed_addr #0 {
start:
  ret i8* %self
}

; core::ptr::unique::Unique<T>::as_ptr
; Function Attrs: inlinehint nonlazybind uwtable
define internal %"std::sys::unix::mutex::Mutex"* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17ha988ebfa6381cd4cE"(i64* nonnull %self) unnamed_addr #0 {
start:
  %_2 = bitcast i64* %self to %"std::sys::unix::mutex::Mutex"*
  ret %"std::sys::unix::mutex::Mutex"* %_2
}

; core::ptr::unique::Unique<T>::as_ref
; Function Attrs: inlinehint nonlazybind uwtable
define internal align 8 dereferenceable(40) %"std::sys::unix::mutex::Mutex"* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ref17hc7abd929032c39b3E"(i64** align 8 dereferenceable(8) %self) unnamed_addr #0 {
start:
  %_3 = load i64*, i64** %self, align 8, !nonnull !3
; call core::ptr::unique::Unique<T>::as_ptr
  %_2 = call %"std::sys::unix::mutex::Mutex"* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ptr17ha988ebfa6381cd4cE"(i64* nonnull %_3)
  br label %bb1

bb1:                                              ; preds = %start
  ret %"std::sys::unix::mutex::Mutex"* %_2
}

; core::ptr::drop_in_place<alloc::boxed::Box<std::sys::unix::mutex::Mutex>>
; Function Attrs: nonlazybind uwtable
define internal void @"_ZN4core3ptr74drop_in_place$LT$alloc..boxed..Box$LT$std..sys..unix..mutex..Mutex$GT$$GT$17h189e3a679bb4808aE"(%"std::sys::unix::mutex::Mutex"** %_1) unnamed_addr #2 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
start:
  %0 = alloca { i8*, i32 }, align 8
  br label %bb3

bb3:                                              ; preds = %start
  %1 = bitcast %"std::sys::unix::mutex::Mutex"** %_1 to i64**
  %2 = load i64*, i64** %1, align 8, !nonnull !3
; call alloc::alloc::box_free
  call void @_ZN5alloc5alloc8box_free17hede2a276aa621aecE(i64* nonnull %2)
  br label %bb1

bb4:                                              ; No predecessors!
  %3 = bitcast %"std::sys::unix::mutex::Mutex"** %_1 to i64**
  %4 = load i64*, i64** %3, align 8, !nonnull !3
; call alloc::alloc::box_free
  call void @_ZN5alloc5alloc8box_free17hede2a276aa621aecE(i64* nonnull %4) #9
  br label %bb2

bb2:                                              ; preds = %bb4
  %5 = bitcast { i8*, i32 }* %0 to i8**
  %6 = load i8*, i8** %5, align 8
  %7 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %0, i32 0, i32 1
  %8 = load i32, i32* %7, align 8
  %9 = insertvalue { i8*, i32 } undef, i8* %6, 0
  %10 = insertvalue { i8*, i32 } %9, i32 %8, 1
  resume { i8*, i32 } %10

bb1:                                              ; preds = %bb3
  ret void
}

; core::ptr::drop_in_place<std::rt::lang_start<()>::{{closure}}>
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @"_ZN4core3ptr85drop_in_place$LT$std..rt..lang_start$LT$$LP$$RP$$GT$..$u7b$$u7b$closure$u7d$$u7d$$GT$17h038bce1dec1881abE"(i64** %_1) unnamed_addr #0 {
start:
  ret void
}

; core::ptr::non_null::NonNull<T>::new_unchecked
; Function Attrs: inlinehint nonlazybind uwtable
define internal nonnull i8* @"_ZN4core3ptr8non_null16NonNull$LT$T$GT$13new_unchecked17h09b145925866306eE"(i8* %ptr) unnamed_addr #0 {
start:
  %0 = alloca i8*, align 8
  store i8* %ptr, i8** %0, align 8
  %1 = load i8*, i8** %0, align 8, !nonnull !3
  ret i8* %1
}

; core::ptr::non_null::NonNull<T>::as_ptr
; Function Attrs: inlinehint nonlazybind uwtable
define internal i8* @"_ZN4core3ptr8non_null16NonNull$LT$T$GT$6as_ptr17hdd02e46a2b0bb51eE"(i8* nonnull %self) unnamed_addr #0 {
start:
  ret i8* %self
}

; core::ptr::drop_in_place<std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>
; Function Attrs: nonlazybind uwtable
define internal void @"_ZN4core3ptr98drop_in_place$LT$std..sync..poison..PoisonError$LT$std..sync..mutex..MutexGuard$LT$i32$GT$$GT$$GT$17h06dc98f4b18e6985E"({ i64*, i8 }* %_1) unnamed_addr #2 {
start:
; call core::ptr::drop_in_place<std::sync::mutex::MutexGuard<i32>>
  call void @"_ZN4core3ptr60drop_in_place$LT$std..sync..mutex..MutexGuard$LT$i32$GT$$GT$17hfdb344ac9615acc8E"({ i64*, i8 }* %_1)
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; core::hint::black_box
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN4core4hint9black_box17hb3e182cb07835373E() unnamed_addr #0 {
start:
  call void asm sideeffect "", "r,~{memory}"({}* undef), !srcloc !7
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; core::sync::atomic::AtomicBool::load
; Function Attrs: inlinehint nonlazybind uwtable
define internal zeroext i1 @_ZN4core4sync6atomic10AtomicBool4load17h535649c9d727243eE(%"core::sync::atomic::AtomicBool"* align 1 dereferenceable(1) %self, i8 %order) unnamed_addr #0 {
start:
  %_6 = bitcast %"core::sync::atomic::AtomicBool"* %self to i8*
  br label %bb1

bb1:                                              ; preds = %start
; call core::sync::atomic::atomic_load
  %_3 = call i8 @_ZN4core4sync6atomic11atomic_load17h1b00c231ba8e31f4E(i8* %_6, i8 %order)
  br label %bb2

bb2:                                              ; preds = %bb1
  %0 = icmp ne i8 %_3, 0
  ret i1 %0
}

; core::sync::atomic::AtomicBool::store
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN4core4sync6atomic10AtomicBool5store17hf7a5813169a62980E(%"core::sync::atomic::AtomicBool"* align 1 dereferenceable(1) %self, i1 zeroext %val, i8 %order) unnamed_addr #0 {
start:
  %_6 = bitcast %"core::sync::atomic::AtomicBool"* %self to i8*
  br label %bb1

bb1:                                              ; preds = %start
  %0 = icmp ule i1 %val, true
  call void @llvm.assume(i1 %0)
  %_7 = zext i1 %val to i8
; call core::sync::atomic::atomic_store
  call void @_ZN4core4sync6atomic12atomic_store17h57870b2bdc335bd2E(i8* %_6, i8 %_7, i8 %order)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret void
}

; core::sync::atomic::AtomicUsize::load
; Function Attrs: inlinehint nonlazybind uwtable
define internal i64 @_ZN4core4sync6atomic11AtomicUsize4load17hcffc57f1db02f0d1E(%"core::sync::atomic::AtomicUsize"* align 8 dereferenceable(8) %self, i8 %order) unnamed_addr #0 {
start:
  %_5 = bitcast %"core::sync::atomic::AtomicUsize"* %self to i64*
  br label %bb1

bb1:                                              ; preds = %start
; call core::sync::atomic::atomic_load
  %0 = call i64 @_ZN4core4sync6atomic11atomic_load17h2f8919e733e4b6d9E(i64* %_5, i8 %order)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i64 %0
}

; core::sync::atomic::atomic_load
; Function Attrs: inlinehint nonlazybind uwtable
define internal i8 @_ZN4core4sync6atomic11atomic_load17h1b00c231ba8e31f4E(i8* %dst, i8 %0) unnamed_addr #0 {
start:
  %1 = alloca i8, align 1
  %order = alloca i8, align 1
  store i8 %0, i8* %order, align 1
  %2 = load i8, i8* %order, align 1, !range !5
  %_3 = zext i8 %2 to i64
  switch i64 %_3, label %bb2 [
    i64 0, label %bb5
    i64 1, label %bb9
    i64 2, label %bb3
    i64 3, label %bb1
    i64 4, label %bb7
  ]

bb2:                                              ; preds = %start
  unreachable

bb5:                                              ; preds = %start
  %3 = load atomic i8, i8* %dst monotonic, align 1
  store i8 %3, i8* %1, align 1
  br label %bb6

bb9:                                              ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17ha5ca6c77bd7d16dbE([0 x i8]* nonnull align 1 bitcast (<{ [40 x i8] }>* @alloc40 to [0 x i8]*), i64 40, %"core::panic::location::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc38 to %"core::panic::location::Location"*)) #10
  unreachable

bb3:                                              ; preds = %start
  %4 = load atomic i8, i8* %dst acquire, align 1
  store i8 %4, i8* %1, align 1
  br label %bb4

bb1:                                              ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17ha5ca6c77bd7d16dbE([0 x i8]* nonnull align 1 bitcast (<{ [49 x i8] }>* @alloc39 to [0 x i8]*), i64 49, %"core::panic::location::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc35 to %"core::panic::location::Location"*)) #10
  unreachable

bb7:                                              ; preds = %start
  %5 = load atomic i8, i8* %dst seq_cst, align 1
  store i8 %5, i8* %1, align 1
  br label %bb8

bb8:                                              ; preds = %bb7
  br label %bb10

bb10:                                             ; preds = %bb6, %bb4, %bb8
  %6 = load i8, i8* %1, align 1
  ret i8 %6

bb4:                                              ; preds = %bb3
  br label %bb10

bb6:                                              ; preds = %bb5
  br label %bb10
}

; core::sync::atomic::atomic_load
; Function Attrs: inlinehint nonlazybind uwtable
define internal i64 @_ZN4core4sync6atomic11atomic_load17h2f8919e733e4b6d9E(i64* %dst, i8 %0) unnamed_addr #0 {
start:
  %1 = alloca i64, align 8
  %order = alloca i8, align 1
  store i8 %0, i8* %order, align 1
  %2 = load i8, i8* %order, align 1, !range !5
  %_3 = zext i8 %2 to i64
  switch i64 %_3, label %bb2 [
    i64 0, label %bb5
    i64 1, label %bb9
    i64 2, label %bb3
    i64 3, label %bb1
    i64 4, label %bb7
  ]

bb2:                                              ; preds = %start
  unreachable

bb5:                                              ; preds = %start
  %3 = load atomic i64, i64* %dst monotonic, align 8
  store i64 %3, i64* %1, align 8
  br label %bb6

bb9:                                              ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17ha5ca6c77bd7d16dbE([0 x i8]* nonnull align 1 bitcast (<{ [40 x i8] }>* @alloc40 to [0 x i8]*), i64 40, %"core::panic::location::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc38 to %"core::panic::location::Location"*)) #10
  unreachable

bb3:                                              ; preds = %start
  %4 = load atomic i64, i64* %dst acquire, align 8
  store i64 %4, i64* %1, align 8
  br label %bb4

bb1:                                              ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17ha5ca6c77bd7d16dbE([0 x i8]* nonnull align 1 bitcast (<{ [49 x i8] }>* @alloc39 to [0 x i8]*), i64 49, %"core::panic::location::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc35 to %"core::panic::location::Location"*)) #10
  unreachable

bb7:                                              ; preds = %start
  %5 = load atomic i64, i64* %dst seq_cst, align 8
  store i64 %5, i64* %1, align 8
  br label %bb8

bb8:                                              ; preds = %bb7
  br label %bb10

bb10:                                             ; preds = %bb6, %bb4, %bb8
  %6 = load i64, i64* %1, align 8
  ret i64 %6

bb4:                                              ; preds = %bb3
  br label %bb10

bb6:                                              ; preds = %bb5
  br label %bb10
}

; core::sync::atomic::atomic_store
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN4core4sync6atomic12atomic_store17h57870b2bdc335bd2E(i8* %dst, i8 %val, i8 %0) unnamed_addr #0 {
start:
  %order = alloca i8, align 1
  store i8 %0, i8* %order, align 1
  %1 = load i8, i8* %order, align 1, !range !5
  %_4 = zext i8 %1 to i64
  switch i64 %_4, label %bb2 [
    i64 0, label %bb5
    i64 1, label %bb3
    i64 2, label %bb9
    i64 3, label %bb1
    i64 4, label %bb7
  ]

bb2:                                              ; preds = %start
  unreachable

bb5:                                              ; preds = %start
  store atomic i8 %val, i8* %dst monotonic, align 1
  br label %bb6

bb3:                                              ; preds = %start
  store atomic i8 %val, i8* %dst release, align 1
  br label %bb4

bb9:                                              ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17ha5ca6c77bd7d16dbE([0 x i8]* nonnull align 1 bitcast (<{ [42 x i8] }>* @alloc44 to [0 x i8]*), i64 42, %"core::panic::location::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc46 to %"core::panic::location::Location"*)) #10
  unreachable

bb1:                                              ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17ha5ca6c77bd7d16dbE([0 x i8]* nonnull align 1 bitcast (<{ [50 x i8] }>* @alloc41 to [0 x i8]*), i64 50, %"core::panic::location::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc43 to %"core::panic::location::Location"*)) #10
  unreachable

bb7:                                              ; preds = %start
  store atomic i8 %val, i8* %dst seq_cst, align 1
  br label %bb8

bb8:                                              ; preds = %bb7
  br label %bb10

bb10:                                             ; preds = %bb6, %bb4, %bb8
  ret void

bb4:                                              ; preds = %bb3
  br label %bb10

bb6:                                              ; preds = %bb5
  br label %bb10
}

; core::alloc::layout::Layout::from_size_align_unchecked
; Function Attrs: inlinehint nonlazybind uwtable
define internal { i64, i64 } @_ZN4core5alloc6layout6Layout25from_size_align_unchecked17ha900d875308b978bE(i64 %size, i64 %align) unnamed_addr #0 {
start:
  %0 = alloca { i64, i64 }, align 8
; call core::num::nonzero::NonZeroUsize::new_unchecked
  %_4 = call i64 @_ZN4core3num7nonzero12NonZeroUsize13new_unchecked17h1b2b7bcf93a2a667E(i64 %align), !range !6
  br label %bb1

bb1:                                              ; preds = %start
  %1 = bitcast { i64, i64 }* %0 to i64*
  store i64 %size, i64* %1, align 8
  %2 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %0, i32 0, i32 1
  store i64 %_4, i64* %2, align 8
  %3 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %0, i32 0, i32 0
  %4 = load i64, i64* %3, align 8
  %5 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %0, i32 0, i32 1
  %6 = load i64, i64* %5, align 8, !range !6
  %7 = insertvalue { i64, i64 } undef, i64 %4, 0
  %8 = insertvalue { i64, i64 } %7, i64 %6, 1
  ret { i64, i64 } %8
}

; core::alloc::layout::Layout::size
; Function Attrs: inlinehint nonlazybind uwtable
define internal i64 @_ZN4core5alloc6layout6Layout4size17hb474def3081fb068E({ i64, i64 }* align 8 dereferenceable(16) %self) unnamed_addr #0 {
start:
  %0 = bitcast { i64, i64 }* %self to i64*
  %1 = load i64, i64* %0, align 8
  ret i64 %1
}

; core::alloc::layout::Layout::align
; Function Attrs: inlinehint nonlazybind uwtable
define internal i64 @_ZN4core5alloc6layout6Layout5align17hac070698c92dbcd1E({ i64, i64 }* align 8 dereferenceable(16) %self) unnamed_addr #0 {
start:
  %0 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %self, i32 0, i32 1
  %_2 = load i64, i64* %0, align 8, !range !6
; call core::num::nonzero::NonZeroUsize::get
  %1 = call i64 @_ZN4core3num7nonzero12NonZeroUsize3get17h7fc5b9bc625db361E(i64 %_2)
  br label %bb1

bb1:                                              ; preds = %start
  ret i64 %1
}

; core::result::Result<T,E>::unwrap
; Function Attrs: inlinehint nonlazybind uwtable
define internal { i64*, i8 } @"_ZN4core6result19Result$LT$T$C$E$GT$6unwrap17hc6eb699df9938d73E"(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture dereferenceable(24) %self, %"core::panic::location::Location"* align 8 dereferenceable(24) %0) unnamed_addr #0 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
start:
  %1 = alloca { i8*, i32 }, align 8
  %e = alloca { i64*, i8 }, align 8
  %2 = bitcast %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* %self to i64*
  %_2 = load i64, i64* %2, align 8, !range !8
  switch i64 %_2, label %bb2 [
    i64 0, label %bb3
    i64 1, label %bb1
  ]

bb2:                                              ; preds = %start
  unreachable

bb3:                                              ; preds = %start
  %3 = bitcast %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* %self to %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Ok"*
  %4 = getelementptr inbounds %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Ok", %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Ok"* %3, i32 0, i32 1
  %5 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %4, i32 0, i32 0
  %t.0 = load i64*, i64** %5, align 8, !nonnull !3
  %6 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %4, i32 0, i32 1
  %7 = load i8, i8* %6, align 8, !range !4
  %t.1 = trunc i8 %7 to i1
  %8 = zext i1 %t.1 to i8
  %9 = insertvalue { i64*, i8 } undef, i64* %t.0, 0
  %10 = insertvalue { i64*, i8 } %9, i8 %8, 1
  ret { i64*, i8 } %10

bb1:                                              ; preds = %start
  %11 = bitcast %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* %self to %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Err"*
  %12 = getelementptr inbounds %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Err", %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>::Err"* %11, i32 0, i32 1
  %13 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %12, i32 0, i32 0
  %14 = load i64*, i64** %13, align 8, !nonnull !3
  %15 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %12, i32 0, i32 1
  %16 = load i8, i8* %15, align 8, !range !4
  %17 = trunc i8 %16 to i1
  %18 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %e, i32 0, i32 0
  store i64* %14, i64** %18, align 8
  %19 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %e, i32 0, i32 1
  %20 = zext i1 %17 to i8
  store i8 %20, i8* %19, align 8
  %_6.0 = bitcast { i64*, i8 }* %e to {}*
; invoke core::result::unwrap_failed
  invoke void @_ZN4core6result13unwrap_failed17h08205c98ce46b680E([0 x i8]* nonnull align 1 bitcast (<{ [43 x i8] }>* @alloc47 to [0 x i8]*), i64 43, {}* nonnull align 1 %_6.0, [3 x i64]* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8], i8*, [0 x i8] }>* @vtable.1 to [3 x i64]*), %"core::panic::location::Location"* align 8 dereferenceable(24) %0) #10
          to label %unreachable unwind label %cleanup

unreachable:                                      ; preds = %bb1
  unreachable

bb4:                                              ; preds = %cleanup
; call core::ptr::drop_in_place<std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>
  call void @"_ZN4core3ptr98drop_in_place$LT$std..sync..poison..PoisonError$LT$std..sync..mutex..MutexGuard$LT$i32$GT$$GT$$GT$17h06dc98f4b18e6985E"({ i64*, i8 }* %e) #9
  br label %bb5

cleanup:                                          ; preds = %bb1
  %21 = landingpad { i8*, i32 }
          cleanup
  %22 = extractvalue { i8*, i32 } %21, 0
  %23 = extractvalue { i8*, i32 } %21, 1
  %24 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 0
  store i8* %22, i8** %24, align 8
  %25 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 1
  store i32 %23, i32* %25, align 8
  br label %bb4

bb5:                                              ; preds = %bb4
  %26 = bitcast { i8*, i32 }* %1 to i8**
  %27 = load i8*, i8** %26, align 8
  %28 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 1
  %29 = load i32, i32* %28, align 8
  %30 = insertvalue { i8*, i32 } undef, i8* %27, 0
  %31 = insertvalue { i8*, i32 } %30, i32 %29, 1
  resume { i8*, i32 } %31
}

; <T as core::convert::Into<U>>::into
; Function Attrs: nonlazybind uwtable
define internal nonnull i8* @"_ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h01175822d19cfacdE"(i8* nonnull %self) unnamed_addr #2 {
start:
; call <core::ptr::non_null::NonNull<T> as core::convert::From<core::ptr::unique::Unique<T>>>::from
  %0 = call nonnull i8* @"_ZN119_$LT$core..ptr..non_null..NonNull$LT$T$GT$$u20$as$u20$core..convert..From$LT$core..ptr..unique..Unique$LT$T$GT$$GT$$GT$4from17h1e495aba80809d0fE"(i8* nonnull %self)
  br label %bb1

bb1:                                              ; preds = %start
  ret i8* %0
}

; <() as std::process::Termination>::report
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @"_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17ha5c4d5e9d1a21070E"() unnamed_addr #0 {
start:
; call <std::process::ExitCode as std::process::Termination>::report
  %0 = call i32 @"_ZN68_$LT$std..process..ExitCode$u20$as$u20$std..process..Termination$GT$6report17h50f4b52762466980E"(i8 0)
  br label %bb1

bb1:                                              ; preds = %start
  ret i32 %0
}

; alloc::alloc::dealloc
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN5alloc5alloc7dealloc17h22a335706f55421fE(i8* %ptr, i64 %0, i64 %1) unnamed_addr #0 {
start:
  %layout = alloca { i64, i64 }, align 8
  %2 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %layout, i32 0, i32 0
  store i64 %0, i64* %2, align 8
  %3 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %layout, i32 0, i32 1
  store i64 %1, i64* %3, align 8
; call core::alloc::layout::Layout::size
  %_4 = call i64 @_ZN4core5alloc6layout6Layout4size17hb474def3081fb068E({ i64, i64 }* align 8 dereferenceable(16) %layout)
  br label %bb1

bb1:                                              ; preds = %start
; call core::alloc::layout::Layout::align
  %_6 = call i64 @_ZN4core5alloc6layout6Layout5align17hac070698c92dbcd1E({ i64, i64 }* align 8 dereferenceable(16) %layout)
  br label %bb2

bb2:                                              ; preds = %bb1
  call void @__rust_dealloc(i8* %ptr, i64 %_4, i64 %_6) #11
  br label %bb3

bb3:                                              ; preds = %bb2
  ret void
}

; alloc::alloc::box_free
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @_ZN5alloc5alloc8box_free17hede2a276aa621aecE(i64* nonnull %0) unnamed_addr #0 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
start:
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca { i8*, i32 }, align 8
  %alloc = alloca %"alloc::alloc::Global", align 1
  %ptr = alloca i64*, align 8
  store i64* %0, i64** %ptr, align 8
; invoke core::ptr::unique::Unique<T>::as_ref
  %_5 = invoke align 8 dereferenceable(40) %"std::sys::unix::mutex::Mutex"* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ref17hc7abd929032c39b3E"(i64** align 8 dereferenceable(8) %ptr)
          to label %bb1 unwind label %cleanup

bb1:                                              ; preds = %start
  store i64 40, i64* %2, align 8
  %size = load i64, i64* %2, align 8
  br label %bb2

bb10:                                             ; preds = %cleanup
  br label %bb11

cleanup:                                          ; preds = %bb7, %bb6, %bb5, %bb4, %bb2, %start
  %4 = landingpad { i8*, i32 }
          cleanup
  %5 = extractvalue { i8*, i32 } %4, 0
  %6 = extractvalue { i8*, i32 } %4, 1
  %7 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %3, i32 0, i32 0
  store i8* %5, i8** %7, align 8
  %8 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %3, i32 0, i32 1
  store i32 %6, i32* %8, align 8
  br label %bb10

bb2:                                              ; preds = %bb1
; invoke core::ptr::unique::Unique<T>::as_ref
  %_9 = invoke align 8 dereferenceable(40) %"std::sys::unix::mutex::Mutex"* @"_ZN4core3ptr6unique15Unique$LT$T$GT$6as_ref17hc7abd929032c39b3E"(i64** align 8 dereferenceable(8) %ptr)
          to label %bb3 unwind label %cleanup

bb3:                                              ; preds = %bb2
  store i64 8, i64* %1, align 8
  %align = load i64, i64* %1, align 8
  br label %bb4

bb4:                                              ; preds = %bb3
; invoke core::alloc::layout::Layout::from_size_align_unchecked
  %9 = invoke { i64, i64 } @_ZN4core5alloc6layout6Layout25from_size_align_unchecked17ha900d875308b978bE(i64 %size, i64 %align)
          to label %bb5 unwind label %cleanup

bb5:                                              ; preds = %bb4
  %layout.0 = extractvalue { i64, i64 } %9, 0
  %layout.1 = extractvalue { i64, i64 } %9, 1
  %_17 = load i64*, i64** %ptr, align 8, !nonnull !3
; invoke core::ptr::unique::Unique<T>::cast
  %_16 = invoke nonnull i8* @"_ZN4core3ptr6unique15Unique$LT$T$GT$4cast17hfbf6cb66d2d175ceE"(i64* nonnull %_17)
          to label %bb6 unwind label %cleanup

bb6:                                              ; preds = %bb5
; invoke <T as core::convert::Into<U>>::into
  %_15 = invoke nonnull i8* @"_ZN50_$LT$T$u20$as$u20$core..convert..Into$LT$U$GT$$GT$4into17h01175822d19cfacdE"(i8* nonnull %_16)
          to label %bb7 unwind label %cleanup

bb7:                                              ; preds = %bb6
; invoke <alloc::alloc::Global as core::alloc::Allocator>::deallocate
  invoke void @"_ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17hd6d4e29c0a031cc1E"(%"alloc::alloc::Global"* nonnull align 1 %alloc, i8* nonnull %_15, i64 %layout.0, i64 %layout.1)
          to label %bb8 unwind label %cleanup

bb8:                                              ; preds = %bb7
  br label %bb9

bb11:                                             ; preds = %bb10
  %10 = bitcast { i8*, i32 }* %3 to i8**
  %11 = load i8*, i8** %10, align 8
  %12 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %3, i32 0, i32 1
  %13 = load i32, i32* %12, align 8
  %14 = insertvalue { i8*, i32 } undef, i8* %11, 0
  %15 = insertvalue { i8*, i32 } %14, i32 %13, 1
  resume { i8*, i32 } %15

bb9:                                              ; preds = %bb8
  ret void
}

; <alloc::alloc::Global as core::alloc::Allocator>::deallocate
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @"_ZN63_$LT$alloc..alloc..Global$u20$as$u20$core..alloc..Allocator$GT$10deallocate17hd6d4e29c0a031cc1E"(%"alloc::alloc::Global"* nonnull align 1 %self, i8* nonnull %ptr, i64 %0, i64 %1) unnamed_addr #0 {
start:
  %layout = alloca { i64, i64 }, align 8
  %2 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %layout, i32 0, i32 0
  store i64 %0, i64* %2, align 8
  %3 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %layout, i32 0, i32 1
  store i64 %1, i64* %3, align 8
; call core::alloc::layout::Layout::size
  %_4 = call i64 @_ZN4core5alloc6layout6Layout4size17hb474def3081fb068E({ i64, i64 }* align 8 dereferenceable(16) %layout)
  br label %bb1

bb1:                                              ; preds = %start
  %4 = icmp eq i64 %_4, 0
  br i1 %4, label %bb5, label %bb2

bb5:                                              ; preds = %bb1
  br label %bb6

bb2:                                              ; preds = %bb1
; call core::ptr::non_null::NonNull<T>::as_ptr
  %_6 = call i8* @"_ZN4core3ptr8non_null16NonNull$LT$T$GT$6as_ptr17hdd02e46a2b0bb51eE"(i8* nonnull %ptr)
  br label %bb3

bb3:                                              ; preds = %bb2
  %5 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %layout, i32 0, i32 0
  %_8.0 = load i64, i64* %5, align 8
  %6 = getelementptr inbounds { i64, i64 }, { i64, i64 }* %layout, i32 0, i32 1
  %_8.1 = load i64, i64* %6, align 8, !range !6
; call alloc::alloc::dealloc
  call void @_ZN5alloc5alloc7dealloc17h22a335706f55421fE(i8* %_6, i64 %_8.0, i64 %_8.1)
  br label %bb4

bb4:                                              ; preds = %bb3
  br label %bb6

bb6:                                              ; preds = %bb5, %bb4
  ret void
}

; <std::process::ExitCode as std::process::Termination>::report
; Function Attrs: inlinehint nonlazybind uwtable
define internal i32 @"_ZN68_$LT$std..process..ExitCode$u20$as$u20$std..process..Termination$GT$6report17h50f4b52762466980E"(i8 %0) unnamed_addr #0 {
start:
  %self = alloca i8, align 1
  store i8 %0, i8* %self, align 1
; call std::sys::unix::process::process_common::ExitCode::as_i32
  %1 = call i32 @_ZN3std3sys4unix7process14process_common8ExitCode6as_i3217h79ec5038914b13e4E(i8* align 1 dereferenceable(1) %self)
  br label %bb1

bb1:                                              ; preds = %start
  ret i32 %1
}

; <std::sync::poison::PoisonError<T> as core::fmt::Debug>::fmt
; Function Attrs: nonlazybind uwtable
define internal zeroext i1 @"_ZN76_$LT$std..sync..poison..PoisonError$LT$T$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h2e67c26302a96307E"({ i64*, i8 }* align 8 dereferenceable(16) %self, %"core::fmt::Formatter"* align 8 dereferenceable(64) %f) unnamed_addr #2 {
start:
  %0 = alloca i128, align 8
  %_4 = alloca %"core::fmt::builders::DebugStruct", align 8
; call core::fmt::Formatter::debug_struct
  %1 = call i128 @_ZN4core3fmt9Formatter12debug_struct17h018d5199e76edfe7E(%"core::fmt::Formatter"* align 8 dereferenceable(64) %f, [0 x i8]* nonnull align 1 bitcast (<{ [11 x i8] }>* @alloc51 to [0 x i8]*), i64 11)
  store i128 %1, i128* %0, align 8
  %2 = bitcast %"core::fmt::builders::DebugStruct"* %_4 to i8*
  %3 = bitcast i128* %0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %2, i8* align 8 %3, i64 16, i1 false)
  br label %bb1

bb1:                                              ; preds = %start
; call core::fmt::builders::DebugStruct::finish_non_exhaustive
  %4 = call zeroext i1 @_ZN4core3fmt8builders11DebugStruct21finish_non_exhaustive17h0f518e02fcc171f4E(%"core::fmt::builders::DebugStruct"* align 8 dereferenceable(16) %_4)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i1 %4
}

; <std::sync::mutex::MutexGuard<T> as core::ops::drop::Drop>::drop
; Function Attrs: inlinehint nonlazybind uwtable
define internal void @"_ZN79_$LT$std..sync..mutex..MutexGuard$LT$T$GT$$u20$as$u20$core..ops..drop..Drop$GT$4drop17he6ee18b679d50667E"({ i64*, i8 }* align 8 dereferenceable(16) %self) unnamed_addr #0 {
start:
  %0 = bitcast { i64*, i8 }* %self to %"std::sync::mutex::Mutex<i32>"**
  %1 = load %"std::sync::mutex::Mutex<i32>"*, %"std::sync::mutex::Mutex<i32>"** %0, align 8, !nonnull !3
  %_3 = getelementptr inbounds %"std::sync::mutex::Mutex<i32>", %"std::sync::mutex::Mutex<i32>"* %1, i32 0, i32 1
  %_5 = getelementptr inbounds { i64*, i8 }, { i64*, i8 }* %self, i32 0, i32 1
; call std::sync::poison::Flag::done
  call void @_ZN3std4sync6poison4Flag4done17hc0a8dd141c4055f4E(%"std::sync::poison::Flag"* align 1 dereferenceable(1) %_3, i8* align 1 dereferenceable(1) %_5)
  br label %bb1

bb1:                                              ; preds = %start
  %2 = bitcast { i64*, i8 }* %self to %"std::sync::mutex::Mutex<i32>"**
  %3 = load %"std::sync::mutex::Mutex<i32>"*, %"std::sync::mutex::Mutex<i32>"** %2, align 8, !nonnull !3
  %_7 = bitcast %"std::sync::mutex::Mutex<i32>"* %3 to i64**
; call std::sys_common::mutex::MovableMutex::raw_unlock
  call void @_ZN3std10sys_common5mutex12MovableMutex10raw_unlock17h37853ab4402fe44aE(i64** align 8 dereferenceable(8) %_7)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret void
}

; basic_mutex::main
; Function Attrs: nonlazybind uwtable
define internal void @_ZN11basic_mutex4main17h08b034717b357bb3E() unnamed_addr #2 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
start:
  %0 = alloca i128, align 8
  %1 = alloca { i8*, i32 }, align 8
  %2 = alloca i128, align 8
  %_7 = alloca %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>", align 8
  %_guard2 = alloca { i64*, i8 }, align 8
  %_4 = alloca %"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>", align 8
  %_guard = alloca { i64*, i8 }, align 8
  %mutex2 = alloca %"std::sync::mutex::Mutex<i32>", align 8
  %mutex = alloca %"std::sync::mutex::Mutex<i32>", align 8
; call std::sync::mutex::Mutex<T>::new
  %3 = call i128 @"_ZN3std4sync5mutex14Mutex$LT$T$GT$3new17h95c9d75482b740b2E"(i32 0)
  store i128 %3, i128* %2, align 8
  %4 = bitcast %"std::sync::mutex::Mutex<i32>"* %mutex to i8*
  %5 = bitcast i128* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %4, i8* align 8 %5, i64 16, i1 false)
  br label %bb1

bb1:                                              ; preds = %start
; invoke std::sync::mutex::Mutex<T>::new
  %6 = invoke i128 @"_ZN3std4sync5mutex14Mutex$LT$T$GT$3new17h95c9d75482b740b2E"(i32 0)
          to label %bb2 unwind label %cleanup

bb2:                                              ; preds = %bb1
  store i128 %6, i128* %0, align 8
  %7 = bitcast %"std::sync::mutex::Mutex<i32>"* %mutex2 to i8*
  %8 = bitcast i128* %0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %7, i8* align 8 %8, i64 16, i1 false)
; invoke std::sync::mutex::Mutex<T>::lock
  invoke void @"_ZN3std4sync5mutex14Mutex$LT$T$GT$4lock17h6ca29baf9cb88884E"(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture sret(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>") dereferenceable(24) %_4, %"std::sync::mutex::Mutex<i32>"* align 8 dereferenceable(16) %mutex)
          to label %bb3 unwind label %cleanup1

bb13:                                             ; preds = %bb12, %cleanup
; call core::ptr::drop_in_place<std::sync::mutex::Mutex<i32>>
  call void @"_ZN4core3ptr55drop_in_place$LT$std..sync..mutex..Mutex$LT$i32$GT$$GT$17h92fac7aa3e213bd1E"(%"std::sync::mutex::Mutex<i32>"* %mutex) #9
  br label %bb14

cleanup:                                          ; preds = %bb8, %bb1
  %9 = landingpad { i8*, i32 }
          cleanup
  %10 = extractvalue { i8*, i32 } %9, 0
  %11 = extractvalue { i8*, i32 } %9, 1
  %12 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 0
  store i8* %10, i8** %12, align 8
  %13 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 1
  store i32 %11, i32* %13, align 8
  br label %bb13

bb3:                                              ; preds = %bb2
; invoke core::result::Result<T,E>::unwrap
  %14 = invoke { i64*, i8 } @"_ZN4core6result19Result$LT$T$C$E$GT$6unwrap17hc6eb699df9938d73E"(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture dereferenceable(24) %_4, %"core::panic::location::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc53 to %"core::panic::location::Location"*))
          to label %bb4 unwind label %cleanup1

bb12:                                             ; preds = %bb11, %cleanup1
; call core::ptr::drop_in_place<std::sync::mutex::Mutex<i32>>
  call void @"_ZN4core3ptr55drop_in_place$LT$std..sync..mutex..Mutex$LT$i32$GT$$GT$17h92fac7aa3e213bd1E"(%"std::sync::mutex::Mutex<i32>"* %mutex2) #9
  br label %bb13

cleanup1:                                         ; preds = %bb7, %bb3, %bb2
  %15 = landingpad { i8*, i32 }
          cleanup
  %16 = extractvalue { i8*, i32 } %15, 0
  %17 = extractvalue { i8*, i32 } %15, 1
  %18 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 0
  store i8* %16, i8** %18, align 8
  %19 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 1
  store i32 %17, i32* %19, align 8
  br label %bb12

bb4:                                              ; preds = %bb3
  store { i64*, i8 } %14, { i64*, i8 }* %_guard, align 8
; invoke std::sync::mutex::Mutex<T>::lock
  invoke void @"_ZN3std4sync5mutex14Mutex$LT$T$GT$4lock17h6ca29baf9cb88884E"(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture sret(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>") dereferenceable(24) %_7, %"std::sync::mutex::Mutex<i32>"* align 8 dereferenceable(16) %mutex2)
          to label %bb5 unwind label %cleanup2

bb5:                                              ; preds = %bb4
; invoke core::result::Result<T,E>::unwrap
  %20 = invoke { i64*, i8 } @"_ZN4core6result19Result$LT$T$C$E$GT$6unwrap17hc6eb699df9938d73E"(%"core::result::Result<std::sync::mutex::MutexGuard<i32>, std::sync::poison::PoisonError<std::sync::mutex::MutexGuard<i32>>>"* noalias nocapture dereferenceable(24) %_7, %"core::panic::location::Location"* align 8 dereferenceable(24) bitcast (<{ i8*, [16 x i8] }>* @alloc55 to %"core::panic::location::Location"*))
          to label %bb6 unwind label %cleanup2

bb11:                                             ; preds = %cleanup2
; call core::ptr::drop_in_place<std::sync::mutex::MutexGuard<i32>>
  call void @"_ZN4core3ptr60drop_in_place$LT$std..sync..mutex..MutexGuard$LT$i32$GT$$GT$17hfdb344ac9615acc8E"({ i64*, i8 }* %_guard) #9
  br label %bb12

cleanup2:                                         ; preds = %bb6, %bb5, %bb4
  %21 = landingpad { i8*, i32 }
          cleanup
  %22 = extractvalue { i8*, i32 } %21, 0
  %23 = extractvalue { i8*, i32 } %21, 1
  %24 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 0
  store i8* %22, i8** %24, align 8
  %25 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 1
  store i32 %23, i32* %25, align 8
  br label %bb11

bb6:                                              ; preds = %bb5
  store { i64*, i8 } %20, { i64*, i8 }* %_guard2, align 8
; invoke core::ptr::drop_in_place<std::sync::mutex::MutexGuard<i32>>
  invoke void @"_ZN4core3ptr60drop_in_place$LT$std..sync..mutex..MutexGuard$LT$i32$GT$$GT$17hfdb344ac9615acc8E"({ i64*, i8 }* %_guard2)
          to label %bb7 unwind label %cleanup2

bb7:                                              ; preds = %bb6
; invoke core::ptr::drop_in_place<std::sync::mutex::MutexGuard<i32>>
  invoke void @"_ZN4core3ptr60drop_in_place$LT$std..sync..mutex..MutexGuard$LT$i32$GT$$GT$17hfdb344ac9615acc8E"({ i64*, i8 }* %_guard)
          to label %bb8 unwind label %cleanup1

bb8:                                              ; preds = %bb7
; invoke core::ptr::drop_in_place<std::sync::mutex::Mutex<i32>>
  invoke void @"_ZN4core3ptr55drop_in_place$LT$std..sync..mutex..Mutex$LT$i32$GT$$GT$17h92fac7aa3e213bd1E"(%"std::sync::mutex::Mutex<i32>"* %mutex2)
          to label %bb9 unwind label %cleanup

bb9:                                              ; preds = %bb8
; call core::ptr::drop_in_place<std::sync::mutex::Mutex<i32>>
  call void @"_ZN4core3ptr55drop_in_place$LT$std..sync..mutex..Mutex$LT$i32$GT$$GT$17h92fac7aa3e213bd1E"(%"std::sync::mutex::Mutex<i32>"* %mutex)
  br label %bb10

bb14:                                             ; preds = %bb13
  %26 = bitcast { i8*, i32 }* %1 to i8**
  %27 = load i8*, i8** %26, align 8
  %28 = getelementptr inbounds { i8*, i32 }, { i8*, i32 }* %1, i32 0, i32 1
  %29 = load i32, i32* %28, align 8
  %30 = insertvalue { i8*, i32 } undef, i8* %27, 0
  %31 = insertvalue { i8*, i32 } %30, i32 %29, 1
  resume { i8*, i32 } %31

bb10:                                             ; preds = %bb9
  ret void
}

; Function Attrs: nonlazybind uwtable
declare i32 @rust_eh_personality(i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*) unnamed_addr #2

; std::rt::lang_start_internal
; Function Attrs: nonlazybind uwtable
declare i64 @_ZN3std2rt19lang_start_internal17h64a8327b226752c1E({}* nonnull align 1, [3 x i64]* align 8 dereferenceable(24), i64, i8**) unnamed_addr #2

; Function Attrs: nonlazybind uwtable
declare i32 @pthread_mutex_lock(%"libc::unix::linux_like::linux::pthread_mutex_t"*) unnamed_addr #2

; Function Attrs: nonlazybind uwtable
declare i32 @pthread_mutex_unlock(%"libc::unix::linux_like::linux::pthread_mutex_t"*) unnamed_addr #2

; std::sys_common::mutex::MovableMutex::new
; Function Attrs: nonlazybind uwtable
declare noalias nonnull align 8 i64* @_ZN3std10sys_common5mutex12MovableMutex3new17h2bb8f0e9b979bf81E() unnamed_addr #2

; std::sync::poison::Flag::new
; Function Attrs: nonlazybind uwtable
declare i8 @_ZN3std4sync6poison4Flag3new17h47827b134c610a5eE() unnamed_addr #2

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; std::panicking::panic_count::is_zero_slow_path
; Function Attrs: cold noinline nonlazybind uwtable
declare zeroext i1 @_ZN3std9panicking11panic_count17is_zero_slow_path17h88139735fad522c1E() unnamed_addr #4

; <std::sys_common::mutex::MovableMutex as core::ops::drop::Drop>::drop
; Function Attrs: nonlazybind uwtable
declare void @"_ZN78_$LT$std..sys_common..mutex..MovableMutex$u20$as$u20$core..ops..drop..Drop$GT$4drop17ha55fce36199af4d5E"(i64** align 8 dereferenceable(8)) unnamed_addr #2

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #5

; core::panicking::panic
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core9panicking5panic17ha5ca6c77bd7d16dbE([0 x i8]* nonnull align 1, i64, %"core::panic::location::Location"* align 8 dereferenceable(24)) unnamed_addr #6

; core::result::unwrap_failed
; Function Attrs: cold noinline noreturn nonlazybind uwtable
declare void @_ZN4core6result13unwrap_failed17h08205c98ce46b680E([0 x i8]* nonnull align 1, i64, {}* nonnull align 1, [3 x i64]* align 8 dereferenceable(24), %"core::panic::location::Location"* align 8 dereferenceable(24)) unnamed_addr #6

; Function Attrs: nounwind nonlazybind uwtable
declare void @__rust_dealloc(i8*, i64, i64) unnamed_addr #7

; core::fmt::Formatter::debug_struct
; Function Attrs: nonlazybind uwtable
declare i128 @_ZN4core3fmt9Formatter12debug_struct17h018d5199e76edfe7E(%"core::fmt::Formatter"* align 8 dereferenceable(64), [0 x i8]* nonnull align 1, i64) unnamed_addr #2

; core::fmt::builders::DebugStruct::finish_non_exhaustive
; Function Attrs: nonlazybind uwtable
declare zeroext i1 @_ZN4core3fmt8builders11DebugStruct21finish_non_exhaustive17h0f518e02fcc171f4E(%"core::fmt::builders::DebugStruct"* align 8 dereferenceable(16)) unnamed_addr #2

; Function Attrs: nonlazybind
define i32 @main(i32 %0, i8** %1) unnamed_addr #8 {
top:
  %2 = sext i32 %0 to i64
; call std::rt::lang_start
  %3 = call i64 @_ZN3std2rt10lang_start17he7e40ff57a395f8aE(void ()* @_ZN11basic_mutex4main17h08b034717b357bb3E, i64 %2, i8** %1)
  %4 = trunc i64 %3 to i32
  ret i32 %4
}

attributes #0 = { inlinehint nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #1 = { noinline nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #2 = { nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #3 = { argmemonly nofree nounwind willreturn }
attributes #4 = { cold noinline nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #5 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #6 = { cold noinline noreturn nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #7 = { nounwind nonlazybind uwtable "probe-stack"="__rust_probestack" "target-cpu"="x86-64" }
attributes #8 = { nonlazybind "target-cpu"="x86-64" }
attributes #9 = { noinline }
attributes #10 = { noreturn }
attributes #11 = { nounwind }

!llvm.module.flags = !{!0, !1, !2}

!0 = !{i32 7, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{i32 2, !"RtLibUseGOT", i32 1}
!3 = !{}
!4 = !{i8 0, i8 2}
!5 = !{i8 0, i8 5}
!6 = !{i64 1, i64 0}
!7 = !{i32 3166152}
!8 = !{i64 0, i64 2}
