part of '../core.dart';

abstract class AppFileType {
  // Image
  static const String jpg = 'jpg';
  static const String jpeg = 'jpeg';
  static const String png = 'png';

  // PDF
  static const String pdf = 'pdf';

  // Doc
  static const String doc = 'doc';
  static const String docx = 'docx';

  // Excel
  static const String xls = 'xls';
  static const String xlsx = 'xlsx';
}

class FileUtils {
  final String filePath;

  FileUtils(this.filePath);

  String get fileType {
    final type = filePath.split('.').last;
    return type;
  }

  String get fileName {
    final name = filePath.split('/').last;
    return name;
  }

  bool get isImage {
    final type = fileType;
    return type == AppFileType.jpg || type == AppFileType.jpeg || type == AppFileType.png;
  }

  bool get isPDF {
    final type = fileType;
    return type == AppFileType.pdf;
  }

  bool get isDoc {
    final type = fileType;
    return type == AppFileType.doc || type == AppFileType.docx;
  }

  bool get isExcel {
    final type = fileType;
    return type == AppFileType.xls || type == AppFileType.xlsx;
  }

  static Future<List<File>> getImages(ImageSource source) async {
    final picker = ImagePicker();

    if (source == ImageSource.camera) {
      final photo = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photo == null) return [];

      final file = File(photo.path);

      return [file];
    }

    final photos = await picker.pickMultiImage(
      imageQuality: 50,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (photos.isEmpty) return [];

    final files = photos.map((e) => File(e.path)).toList().toList();

    return files;
  }

  ///get image from camera or gallery
  static Future<dynamic> getImage2({
    PickerImageType type = PickerImageType.camera,
    required BuildContext context,
    int maxAssets = 5,
  }) async {
    final picker = ImagePicker();
    Utils.dismissKeyboard();
    String path = '';
    final lang = Utils.languageOf(context);
    if (type == PickerImageType.camera) {
      XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (!Utils.isNullOrEmpty(image)) {
        path = image?.path ?? '';
      }
    } else if (type == PickerImageType.imageGallery) {
      List<AssetEntity>? images = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 1,
          textDelegate: OtherAssetPickerTextDelegate(lang),
          requestType: RequestType.image,
        ),
      );
      if (!Utils.isNullOrEmpty(images)) {
        final File? file = await images![0].file;
        if (!Utils.isNullOrEmpty(file)) {
          path = file?.path ?? '';
        }
      }
    } else if (type == PickerImageType.multiImageGallery) {
      List<AssetEntity>? images = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxAssets,
          textDelegate: OtherAssetPickerTextDelegate(lang),
          requestType: RequestType.image,
        ),
      );
      List<String> paths = [];
      if (!Utils.isNullOrEmpty(images)) {
        for (var val in images!) {
          File? file = await val.file;
          if (!Utils.isNullOrEmpty(file)) {
            paths.add(file?.path ?? '');
          }
        }
      }
      return paths;
    }
    return path;
  }

  static Future<List<File>> getFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        AppFileType.jpg,
        AppFileType.jpeg,
        AppFileType.png,
        AppFileType.pdf,
        AppFileType.doc,
        AppFileType.docx,
        AppFileType.xls,
        AppFileType.xlsx,
      ],
    );

    if (result == null) return [];

    final files = result.files;

    if (files.isEmpty) return [];

    final paths = files.map((e) => e.path).where((element) => element != null).toList();

    final list = paths.map((e) => File(e!)).toList();

    return list;
  }

  static String getFileType(String fileName) {
    return ".${fileName.split('.').last}".toUpperCase();
  }

  ///check image type and size
  static String checkImageValid(File image, {required BuildContext context}) {
    final lang = Utils.languageOf(context);
    if (image.readAsBytesSync().lengthInBytes <= 10485760) {
      if (getFileType(image.path) != '.PNG' &&
          getFileType(image.path) != '.JPEG' &&
          getFileType(image.path) != '.JPG') {
        return lang.validateFileType;
      }
    } else {
      return lang.validateImage;
    }
    return '';
  }
}

enum PickerImageType {
  camera,
  imageGallery,
  multiImageGallery,
}

class OtherAssetPickerTextDelegate extends AssetPickerTextDelegate {
  final AppLocalizations lang;

  OtherAssetPickerTextDelegate(this.lang);

  @override
  String get languageCode => lang.languageCode;

  @override
  String get confirm => lang.confirm;

  @override
  String get cancel => lang.cancel;

  @override
  String get edit => lang.edit;

  @override
  String get gifIndicator => lang.gifIndicator;

  @override
  String get loadFailed => lang.loadFailed;

  @override
  String get original => lang.original;

  @override
  String get preview => lang.preview;

  @override
  String get select => lang.select;

  @override
  String get emptyList => lang.emptyList;

  @override
  String get unSupportedAssetType => lang.unSupportedAssetType;

  @override
  String get unableToAccessAll => lang.unableToAccessAll;

  @override
  String get viewingLimitedAssetsTip => lang.viewingLimitedAssetsTip;

  @override
  String get changeAccessibleLimitedAssets => lang.changeAccessibleLimitedAssets;

  @override
  String get accessAllTip => lang.accessAllTip;

  @override
  String get goToSystemSettings => lang.goToSystemSettings;

  @override
  String get accessLimitedAssets => lang.accessLimitedAssets;

  @override
  String get accessiblePathName => lang.accessiblePathName;

  @override
  String get sTypeAudioLabel => lang.sTypeAudioLabel;

  @override
  String get sTypeImageLabel => lang.sTypeImageLabel;

  @override
  String get sTypeVideoLabel => lang.sTypeVideoLabel;

  @override
  String get sTypeOtherLabel => lang.sTypeOtherLabel;

  @override
  String get sActionPlayHint => lang.sActionPlayHint;

  @override
  String get sActionPreviewHint => lang.sActionPreviewHint;

  @override
  String get sActionSelectHint => lang.sActionSelectHint;

  @override
  String get sActionSwitchPathLabel => lang.sActionSwitchPathLabel;

  @override
  String get sActionUseCameraHint => lang.sActionUseCameraHint;

  @override
  String get sNameDurationLabel => lang.sNameDurationLabel;

  @override
  String get sUnitAssetCountLabel => lang.sUnitAssetCountLabel;
}
