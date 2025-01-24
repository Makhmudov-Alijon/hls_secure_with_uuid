// Future<void> downloadOrContinue({
//   required DownloadTask downloadTask,
//   required LocalHlsModelIsar hls,
//   required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
//       onDownloadComplete,
//   required void Function(LocalHlsErrorState error)? onError,
// }) async {
//   var lastCheckForPauseOrDeleted = DateTime.now();
//
//   final startTimee = DateTime.now();
//   _startDownloading(where: 'line 222 ${startTimee}');
//   _downloadingHlss = hls.iD;
//   LocalHlsModelIsar? theTarget = await moviesController.updateHlsStatus(
//     hls.id,
//     LocalHlsDownloadingState(),
//     where: 'start downloading 168 ',
//   );
//   Isolate? theIsolate;
//   ReceivePort? thePort;
//   late LocalHlsState resultState;
//   int lastUpdatedFor = 0;
//   void dispose() {
//     lastUpdatedFor = 0;
//     progressUpdateTimer?.cancel();
//     progressUpdateTimer = null;
//     thePort?.close();
//     thePort = null;
//     theIsolate?.kill(priority: Isolate.immediate);
//     theIsolate = null;
//   }
//
//   try {
//     final tasks = Map<String, String>.fromEntries(
//       downloadTask.items.where((e) => !e.isDownloaded).map(
//             (e) => e.getForIsolateMap,
//           ),
//     );
//
//
//     final preloadedTasksCount = downloadTask.items.length - tasks.length;
//     final allTasksCompleted = Completer<void>();
//     if (tasks.isNotEmpty) {
//       thePort = ReceivePort();
//       var count = 0;
//
//       void _timer(timer) {
//         if (state == HlsDownloaderState.downloading) {
//           final progress = calculateProgress(
//             totalLength: downloadTask.items.length,
//             doneLength: count + preloadedTasksCount,
//             // + failedTasks.length,
//           );
//           final speed = lastUpdatedFor == count
//               ? 0.0
//               : calculateDownloadSpeed(
//                   startTime: startTimee,
//                   mbPerSegment: downloadTask.mbPerSegment,
//                   downloadedSegments: count,
//                 );
//
//           // This code runs every half a second and updates the UI
//           lastUpdatedFor = count;
//           localHlsMovieController(hls.iD).updateProgress(
//             progress: progress,
//             speed: speed,
//           );
//         } else {
//           timer.cancel();
//         }
//       }
//
//       progressUpdateTimer = Timer.periodic(
//         const Duration(milliseconds: 300),
//         _timer,
//       );
//
//       theIsolate = await Isolate.spawn(
//         retryWithoutExiting,
//         DownloadFullTask2(
//           tasks: tasks,
//           sendPort: thePort!.sendPort,
//         ),
//       );
//       late SendPort isolateSendPort;
//
//       thePort!.listen(
//         (message) async {
//           if (message is SendPort) {
//             isolateSendPort = message;
//           }
//           if (message is int) {
//             switch (message) {
//               case DM.waitForNetwork:
//                 {
//                    resultState = LocalHlsWaitingForNetworkState();
//                   try {
//                     if (!allTasksCompleted.isCompleted) {
//                       allTasksCompleted.complete();
//                     } else {
//                       final v = 0;
//                     }
//                   } catch (e) {
//                     print('<>< ><> complete exception doneFull : $e');
//                   }
//
//                   break;
//                 }
//               case DM.error:
//                 {
//                   final retry = canRetry();
//                   if (retry) {
//                     isolateSendPort.send(DM.error);
//                   } else {
//                     isolateSendPort.send(DM.goBack);
//                   }
//                   break;
//                 }
//               case DM.gottenBack:
//               case DM.goBackWithError:
//                 {
//                   resultState =
//                       count + preloadedTasksCount == downloadTask.items.length
//                           ? LocalHlsCompleteState()
//                           : message == DM.goBackWithError
//                               ? LocalHlsErrorState()
//                               : LocalHlsPauseState();
//
//                   try {
//                     if (!allTasksCompleted.isCompleted) {
//                       allTasksCompleted.complete();
//                     }
//                   } catch (e) {
//                     print('<>< ><> complete exception : $e');
//                   }
//
//                   break;
//                 }
//               case DM.doneFor:
//                 {
//                   count++;
//
//                   if (DateTime.now()
//                           .difference(lastCheckForPauseOrDeleted)
//                           .inMilliseconds >
//                       300) {
//                     final check = ref
//                         .read(localeHlsIsarProvider)
//                         .getHlsDownloadStatusTypee(
//                           hlsId: hls.id,
//                         );
//
//                     if (check is LocalHlsWaitingForNetworkState) {
//                        isolateSendPort.send(DM.waitForNetwork);
//                     } else if (check is LocalHlsPauseState ||
//                         check is LocalHlsDeletedState) {
//                       isolateSendPort.send(DM.goBack);
//                     }
//
//                     lastCheckForPauseOrDeleted = DateTime.now();
//                   }
//
//                   break;
//                 }
//               case DM.doneFull:
//                 {
//                   resultState =
//                       count + preloadedTasksCount == downloadTask.items.length
//                           ? LocalHlsCompleteState()
//                           : LocalHlsErrorState();
//
//                   try {
//                     if (!allTasksCompleted.isCompleted) {
//                       allTasksCompleted.complete();
//                     } else {
//                       final v = 0;
//                     }
//                   } catch (e) {
//                     print('<>< ><> complete exception doneFull : $e');
//                   }
//
//                   break;
//                 }
//             }
//           }
//         },
//       );
//     } else {
//       resultState = LocalHlsCompleteState();
//       allTasksCompleted.complete();
//     }
//     await allTasksCompleted.future;
//
//
//
//     dispose();
//
//     theTarget = await moviesController.updateHlsStatus(
//       hls.id,
//       resultState,
//       where: 'after download complete 402',
//     );
//
//     _downloadingHlss = null;
//     _isolateRunning = false;
//     if (resultState is LocalHlsErrorState) {
//       _stopDownloading(where: 'line 411');
//       onError?.call(LocalHlsErrorState());
//     } else if (resultState is LocalHlsDeletedState) {
//       _stopDownloading(where: 'line 414');
//       await moviesController.deleteHls(hls: hls);
//     } else if (resultState is LocalHlsWaitingForNetworkState) {
//       _stopDownloading(where: 'waiting for network');
//       return;
//     } else {
//       _stopDownloading(where: 'line 417');
//     }
//
//     if (onDownloadComplete != null &&
//         resultState is LocalHlsCompleteState &&
//         theTarget != null) {
//       await onDownloadComplete.call(theTarget, ref);
//     } else {
//       final v = 0;
//     }
//
//     await checkForNextQueue(
//       where: ' after complete: 373',
//       onDownloadComplete: onDownloadComplete,
//       onError: onError,
//     );
//   } catch (e) {
//     theTarget = await moviesController.updateHlsStatus(
//       hls.id,
//       LocalHlsErrorState(),
//       where: 'after download complete 402',
//     );
//     dispose();
//     _stopDownloading(where: 'catch line 421');
//   }
// }

// Future<void> downloadOrContinue({
//   required DownloadTask downloadTask,
//   required LocalHlsModelIsar hls,
//   required Future<void> Function(LocalHlsModelIsar hls, Ref ref)?
//   onDownloadComplete,
//   required void Function(LocalHlsErrorState error)? onError,
// }) async {
//   DateTime startTimee = DateTime.now();
//   _startDownloading(where: 'line 222 ${startTimee}');
//   _downloadingHlss = hls.iD;
//   LocalHlsModelIsar? theTarget = await moviesController.updateHlsStatus(
//     hls.id,
//     LocalHlsDownloadingState(),
//     where: 'start downloading 168 ',
//   );
//   late SendPort isolateSendPort;
//   Isolate? theIsolate;
//   ReceivePort? thePort;
//   late LocalHlsState resultState;
//   int lastUpdatedFor = 0;
//   void dispose() {
//     lastUpdatedFor = 0;
//     progressUpdateTimer?.cancel();
//     progressUpdateTimer = null;
//     thePort?.close();
//     thePort = null;
//     theIsolate?.kill(priority: Isolate.immediate);
//     theIsolate = null;
//   }
//
//   try {
//     final tasks = Map<String, String>.fromEntries(
//       downloadTask.items.where((e) => !e.isDownloaded).map(
//             (e) => e.getForIsolateMap,
//       ),
//     );
//
//
//     final preloadedTasksCount = downloadTask.items.length - tasks.length;
//     final allTasksCompleted = Completer<void>();
//     if (tasks.isNotEmpty) {
//       thePort = ReceivePort();
//       var count = 0;
//       var subtractionValue = 0;
//       void checkState() {
//         final check =
//         ref.read(localeHlsIsarProvider).getHlsDownloadStatusTypee(
//           hlsId: hls.id,
//         );
//
//         if (check is LocalHlsWaitingForNetworkState) {
//           isolateSendPort.send(DM.waitForNetwork);
//         } else if (check is LocalHlsPauseState) {
//           isolateSendPort.send(DM.goBack);
//         } else if (check is LocalHlsDeletedState) {
//           isolateSendPort.send(DM.deleted);
//         }
//       }
//
//       void _timer(timer) {
//         checkState();
//         if (state == HlsDownloaderState.downloading) {
//           final progress = calculateProgress(
//             totalLength: downloadTask.items.length,
//             doneLength: count + preloadedTasksCount,
//             // + failedTasks.length,
//           );
//
//           if (lastUpdatedFor == count) {
//             startTimee = DateTime.now();
//             subtractionValue = count;
//           }
//           final speed = calculateDownloadSpeed(
//             startTime: startTimee,
//             mbPerSegment: downloadTask.mbPerSegment,
//             downloadedSegments: count - subtractionValue,
//           );
//
//           // This code runs every half a second and updates the UI
//           lastUpdatedFor = count;
//           localHlsMovieController(hls.iD).updateProgress(
//             progress: progress,
//             speed: speed,
//           );
//         } else {
//           timer.cancel();
//         }
//       }
//
//       progressUpdateTimer = Timer.periodic(
//         const Duration(milliseconds: 1000),
//         _timer,
//       );
//
//       theIsolate = await Isolate.spawn(
//         retryWithoutExiting3,
//         DownloadFullTask2(
//           tasks: tasks,
//           sendPort: thePort!.sendPort,
//         ),
//       );
//
//       thePort!.listen(
//             (message) async {
//           if (message is SendPort) {
//             isolateSendPort = message;
//           }
//           if (message is int) {
//             switch (message) {
//               case DM.deleted:
//               case DM.error:
//               case DM.goBack:
//               case DM.waitForNetwork:
//                 {
//                   if (message == DM.deleted) {
//                     resultState = LocalHlsDeletedState();
//                   } else {
//                     resultState = count + preloadedTasksCount ==
//                         downloadTask.items.length
//                         ? LocalHlsCompleteState()
//                         : message == DM.waitForNetwork
//                         ? LocalHlsWaitingForNetworkState()
//                         : (message == DM.error
//                         ? LocalHlsErrorState()
//                         : LocalHlsPauseState());
//                   }
//
//                   try {
//                     if (!allTasksCompleted.isCompleted) {
//                       allTasksCompleted.complete();
//                     }
//                   } catch (e) {
//                     print('<>< ><> complete exception : $e');
//                   }
//
//                   break;
//                 }
//               case DM.doneFor:
//                 {
//                   count++;
//
//                   break;
//                 }
//               case DM.doneFull:
//                 {
//                   resultState =
//                   count + preloadedTasksCount == downloadTask.items.length
//                       ? LocalHlsCompleteState()
//                       : LocalHlsErrorState();
//
//                   try {
//                     if (!allTasksCompleted.isCompleted) {
//                       allTasksCompleted.complete();
//                     } else {
//                       final v = 0;
//                     }
//                   } catch (e) {
//                     print('<>< ><> complete exception doneFull : $e');
//                   }
//
//                   break;
//                 }
//             }
//           }
//         },
//       );
//     } else {
//       resultState = LocalHlsCompleteState();
//       allTasksCompleted.complete();
//     }
//     await allTasksCompleted.future;
//
//
//
//     dispose();
//
//     theTarget = await moviesController.updateHlsStatus(
//       hls.id,
//       resultState,
//       where: 'after download complete 402',
//     );
//
//     _downloadingHlss = null;
//     _isolateRunning = false;
//     if (resultState is LocalHlsErrorState) {
//       _stopDownloading(where: 'line 411');
//       onError?.call(LocalHlsErrorState());
//     } else if (resultState is LocalHlsDeletedState) {
//       _stopDownloading(where: 'line 414');
//       await moviesController.deleteHls(hls: hls);
//     } else if (resultState is LocalHlsWaitingForNetworkState) {
//       _stopDownloading(where: 'waiting for network');
//       return;
//     } else {
//       _stopDownloading(where: 'line 417');
//     }
//
//     if (onDownloadComplete != null &&
//         resultState is LocalHlsCompleteState &&
//         theTarget != null) {
//       await onDownloadComplete.call(theTarget, ref);
//     } else {
//       final v = 0;
//     }
//
//     await checkForNextQueue(
//       where: ' after complete: 373',
//       onDownloadComplete: onDownloadComplete,
//       onError: onError,
//     );
//   } catch (e) {
//     theTarget = await moviesController.updateHlsStatus(
//       hls.id,
//       LocalHlsErrorState(),
//       where: 'after download complete 402',
//     );
//     dispose();
//     _stopDownloading(where: 'catch line 421');
//   }
// }
