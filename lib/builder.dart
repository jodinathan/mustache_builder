// Copyright (c) 2018, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';
import 'package:mustache/mustache.dart';

HtmlTemplateBuilder htmlBuilder(BuilderOptions options) =>
    HtmlTemplateBuilder();

PostProcessBuilder templateCleanupBuilder(BuilderOptions options) =>
    FileDeletingBuilder(['.mustache.html'],
        isEnabled: options.config['enabled'] as bool ?? false);

class HtmlTemplateBuilder extends Builder {
  @override
  final buildExtensions = {
    '.mustache.html': ['.html']
  };

  @override
  Future build(BuildStep buildStep) async {
    var content = await buildStep.readAsString(buildStep.inputId);
    var pubspecAssetId =
    AssetId(buildStep.inputId.package, 'pubspec.yaml');

    // Check if we can load the pubspec file.
    if (!await buildStep.canRead(pubspecAssetId)) {
      log.severe(
          'Cannot read pubspec.yaml! Make sure it is included as a'
              ' source in your target.');
      return;
    }

    var pubspec = await buildStep.readAsString(pubspecAssetId);
    var pubspecYaml = loadYaml(pubspec);

    // Check if the yaml file have been parsed well.
    if (pubspecYaml == null) {
      log.severe(
          'Cannot read pubspec.yaml! Make sure it is included as a source'
              ' in your target.');
      return;
    }

    var template = new Template(content,
        name: buildStep.inputId.toString());
    var opts = {};

    if (pubspecYaml is Map) {
      for (var key in pubspecYaml.keys) {
        opts['pubspec_$key'] = pubspecYaml[key];
      }
    }

    var output = template.renderString(opts);

    await buildStep.writeAsString(
      buildStep.inputId.changeExtension('').changeExtension('.html'),
      output,
    );
  }
}

