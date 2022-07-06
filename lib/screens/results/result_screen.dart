
import 'dart:typed_data';

import 'package:balance/floor/measurement_database.dart';
import 'package:balance/floor/test_database_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance/bloc/results/result_bloc.dart';

import 'package:balance/screens/results/widgets/result_features_items.dart';
import 'package:balance/screens/results/widgets/result_info_item.dart';
import 'package:provider/provider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:screenshot/screenshot.dart';

import 'dart:ui' as ui;

class ResultScreen extends StatelessWidget {

  //Create an instance of ScreenshotController
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Provider.of<MeasurementDatabase>(context, listen: false);
    // Get the resultId from the arguments
    final Test test = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: BlocProvider(
        create: (context) => ResultBloc.create(
          Provider.of<MeasurementDatabase>(context, listen: false),
          test?.id
        ),
        child: BlocConsumer<ResultBloc, ResultState>(
          listenWhen: (_, current) => current is ResultError || current is ResultExportSuccess,
          listener: (context, state) {
            Scaffold.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: state is ResultExportSuccess
                ? Text('export_success_txt'.tr())
                : Text('unexpected_error_txt'.tr())
            ));
          },
          buildWhen: (previous, current) {
            return !(current is ResultExportSuccess) &&
              !(previous is ResultSuccess && current is ResultError);
          },
          builder: (context, state) {
            // Display the loading screen
            if (state is ResultLoading)
              return _loadingScreen(context, test);
            // Display the data screen
            else
              return _successScreen(context, test, state is ResultSuccess? state: null);
          },
        ),
      ),
    );
  }

  /// Build the loading screen
  Widget _loadingScreen(BuildContext context, Test test) => Scaffold(
    appBar: AppBar(
      title: Text("${'test_txt'.tr()} ${test?.id}"),
      elevation: 0,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Result info card and appbar overflow
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.only(bottom: 26),
                color: Theme.of(context).primaryColor,
              ),
            ),
            // Result info card
            ResultInfoItem(test)
          ]
        ),
        Expanded(
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator()
            ),
          ),
        )
      ],
    )
  );

  /// Build the screen with data
  Widget _successScreen(BuildContext context, Test test, ResultSuccess success) {

    return CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          title: Text("${'test_txt'.tr()} ${test?.id ?? ""}"),
          floating: false,
          actions: [
            PopupMenuButton<String>(
              onSelected: (selected) {
                if (selected == "export") {
                  print("Exporting test ${test?.id}");
                  context.bloc<ResultBloc>().add(ExportResult(test?.id));
                } else if (selected == "screenshot") {
                  _screenshotController.capture().then((Uint8List image) {
                    print("Screenshotting Test ${test?.id}");
                    context.bloc<ResultBloc>().add(SaveScreenshot(test?.id, image));
                    context.bloc<ResultBloc>().add(FetchResult(test?.id));
                  }).catchError((onError) {
                    print(onError);
                  });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: "export",
                  child: Text('export_txt'.tr()),
                ),
                PopupMenuItem<String>(
                  value: "screenshot",
                  child: Text('save_test_txt'.tr()),
                )
              ],
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            Screenshot(
              controller: _screenshotController,
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 26),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      // Result info card
                      ResultInfoItem(test),
                    ]
                  ),
                  ResultFeaturesItems(success?.statokinesigram),
                ],
              )
            ),
          ])
        )
      ]
    );
  }
}

extension ScreenshotExtension on ScreenshotController {
  ///
  /// Value for [delay] should increase with widget tree size. Prefered value is 1 seconds
  ///
  ///[context] parameter is used to Inherit App Theme and MediaQuery data.
  ///
  ///
  ///
  Future<Uint8List> captureFromWidget(
    Widget widget, {
      Duration delay: const Duration(seconds: 1),
      double pixelRatio,
      BuildContext context,
      Size targetSize,

    }) async {
      ui.Image image = await widgetToUiImage(widget,
          delay: delay,
          pixelRatio: pixelRatio,
          context: context,
          targetSize: targetSize);
      final ByteData byteData =  await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData.buffer.asUint8List();
    }

  static Future<ui.Image> widgetToUiImage(
      Widget widget, {
        Duration delay: const Duration(seconds: 1),
        double pixelRatio,
        BuildContext context,
        Size targetSize,
      }) async {
    ///
    ///Retry counter
    ///
    int retryCounter = 3;
    bool isDirty = false;

    Widget child = widget;

    if (context != null) {
      ///
      ///Inherit Theme and MediaQuery of app
      ///
      ///
      child = InheritedTheme.captureAll(
        context,
        MediaQuery(data: MediaQuery.of(context), child: Material(child:child,color: Colors.transparent, )),
      );
    }

    final RenderRepaintBoundary repaintBoundary =  RenderRepaintBoundary();

    Size logicalSize = targetSize ??
        ui.window.physicalSize / ui.window.devicePixelRatio; // Adapted
    Size imageSize = targetSize ?? ui.window.physicalSize; // Adapted

    assert(logicalSize.aspectRatio.toStringAsPrecision(5) ==
        imageSize.aspectRatio.toStringAsPrecision(5));    // Adapted (toPrecision was not available)

    final RenderView renderView = RenderView(
      window: ui.window,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: pixelRatio ?? 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(
        onBuildScheduled: () {
          ///
          ///current render is dirty, mark it.
          ///
          isDirty = true;
        });

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
    RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: child,
        )).attachToRenderTree(
      buildOwner,
    );
    ////
    ///Render Widget
    ///
    ///
    buildOwner.buildScope(
      rootElement,
    );
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image image;

    do {
      ///
      ///Reset the dirty flag
      ///
      ///
      isDirty = false;

      image = await repaintBoundary.toImage(
          pixelRatio: pixelRatio ?? (imageSize.width / logicalSize.width));

      ///
      ///This delay sholud increas with Widget tree Size
      ///
      await Future.delayed(delay);

      ///
      ///Check does this require rebuild
      ///
      ///
      if (isDirty) {
        ///
        ///Previous capture has been updated, re-render again.
        ///
        ///
        buildOwner.buildScope(
          rootElement,
        );
        buildOwner.finalizeTree();
        pipelineOwner.flushLayout();
        pipelineOwner.flushCompositingBits();
        pipelineOwner.flushPaint();
      }
      retryCounter--;

      ///
      ///retry untill capture is successfull
      ///
    } while (isDirty && retryCounter >= 0);


    return image;   // Adapted to directly return the image and not the Uint8List
  }
}