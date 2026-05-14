// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'DevPilotAI';

  @override
  String get appBrand => 'DevPilot AI by JakapanK';

  @override
  String appVersionLabel(String version, String buildNumber) {
    return 'เวอร์ชัน $version ($buildNumber)';
  }

  @override
  String get generator => 'สร้างผลลัพธ์';

  @override
  String get templates => 'เทมเพลต';

  @override
  String get history => 'ประวัติ';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get english => 'อังกฤษ';

  @override
  String get thai => 'ไทย';

  @override
  String get selectTemplate => 'เลือกเทมเพลต';

  @override
  String get userCommand => 'คำสั่งผู้ใช้';

  @override
  String get userCommandHint =>
      'อธิบาย requirement, code, release หรืองานที่ต้องการ...';

  @override
  String get generate => 'สร้าง';

  @override
  String get result => 'ผลลัพธ์';

  @override
  String get emptyResult => 'ผลลัพธ์ที่สร้างจะแสดงที่นี่';

  @override
  String get copy => 'คัดลอก';

  @override
  String get save => 'บันทึก';

  @override
  String get delete => 'ลบ';

  @override
  String get edit => 'แก้ไข';

  @override
  String get createTemplate => 'สร้างเทมเพลต';

  @override
  String get editTemplate => 'แก้ไขเทมเพลต';

  @override
  String get searchTemplates => 'ค้นหาเทมเพลต';

  @override
  String get noTemplateSearchResults => 'ไม่พบเทมเพลตที่ตรงกับคำค้นหา';

  @override
  String get sortBy => 'เรียงตาม';

  @override
  String get sortNameAsc => 'ชื่อ A-Z';

  @override
  String get sortNameDesc => 'ชื่อ Z-A';

  @override
  String get sortCategoryAsc => 'หมวดหมู่ A-Z';

  @override
  String get sortNewest => 'แก้ไขล่าสุด';

  @override
  String get sortOldest => 'แก้ไขเก่าสุด';

  @override
  String get pageSize => 'จำนวนต่อหน้า';

  @override
  String get previousPage => 'หน้าก่อนหน้า';

  @override
  String get nextPage => 'หน้าถัดไป';

  @override
  String get createdAt => 'สร้างเมื่อ';

  @override
  String get updatedAt => 'แก้ไขล่าสุด';

  @override
  String get confirmDeleteTitle => 'ยืนยันการลบ';

  @override
  String confirmDeleteTemplatesMessage(int count) {
    return 'ลบเทมเพลต $count รายการ?';
  }

  @override
  String templatePageStatus(int currentPage, int totalPages, int totalItems) {
    return 'หน้า $currentPage จาก $totalPages ($totalItems เทมเพลต)';
  }

  @override
  String get selectAll => 'เลือกทั้งหมด';

  @override
  String get clearSelection => 'ยกเลิกการเลือก';

  @override
  String selectedTemplates(int count) {
    return 'เลือกแล้ว $count รายการ';
  }

  @override
  String get templateName => 'ชื่อเทมเพลต';

  @override
  String get description => 'คำอธิบาย';

  @override
  String get category => 'หมวดหมู่';

  @override
  String get promptInstruction => 'คำสั่ง Prompt';

  @override
  String get exampleInput => 'ตัวอย่างข้อมูลเข้า';

  @override
  String get outputFormat => 'รูปแบบผลลัพธ์';

  @override
  String get languagePreference => 'ภาษาที่ต้องการ';

  @override
  String get promptPreview => 'ตัวอย่าง Prompt';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get saved => 'บันทึกแล้ว';

  @override
  String get apiSettings => 'ตั้งค่าผู้ให้บริการ AI';

  @override
  String get provider => 'ผู้ให้บริการ';

  @override
  String get apiKey => 'API key';

  @override
  String get baseUrl => 'Base URL';

  @override
  String get model => 'Model';

  @override
  String get releaseNotesTitle => 'Release Notes';

  @override
  String get releaseNotesIntro =>
      'DevPilotAI ช่วยให้ทีมเปลี่ยน requirement ให้เป็นผลงานจาก AI ที่นำไปใช้ต่อได้จริง';

  @override
  String get releaseVersion100Title => 'เวอร์ชัน 1.0.0';

  @override
  String get releaseVersion100Date => 'รุ่นแรกของ workspace สำหรับ developer';

  @override
  String get releaseVersion100Templates =>
      'หน้า Templates รองรับค้นหา จัดกลุ่มตามหมวดหมู่ sort จากหัวตาราง paging เลข row multi-select และ confirm ก่อนลบ';

  @override
  String get releaseVersion100Generator =>
      'หน้า Generator เป็น split workspace มีการเลือก template, ใส่ context ยาว, preview prompt, แสดงผลแบบ formatted, copy และบันทึก history';

  @override
  String get releaseVersion100History =>
      'หน้า History ค้นหาและกรองผลลัพธ์ตาม keyword, template, category และช่วงวันที่ได้';

  @override
  String get releaseVersion100Settings =>
      'หน้า Settings รองรับสลับภาษาไทย/อังกฤษ ตั้งค่า OpenAI-compatible provider แสดง release notes ตาม version และสารจากผู้พัฒนา';

  @override
  String get releaseVersion100DeveloperPacks =>
      'เพิ่ม Developer Template Packs เช่น API Spec Reviewer, PR Description Generator, Error Log Analyzer, Security Review Checklist, Performance Bottleneck Analyzer และ Backend Unit Test Generator';

  @override
  String get developerMessageTitle => 'สารจากผู้พัฒนา';

  @override
  String get developerMessageIntro =>
      'แอปนี้ถูกสร้างขึ้นเพื่อลดงานวิเคราะห์ซ้ำ ๆ และช่วยให้ทีม Product, QA และ Engineering เริ่มงานจาก draft ที่มีคุณภาพขึ้น';

  @override
  String get developerMessageFeatures =>
      'จุดเด่นคือ skill templates ที่ใช้ซ้ำได้, การเชื่อมต่อ OpenAI-compatible API, ประวัติแบบ local-first, หน้าจอ responsive สำหรับ web/mobile และ workflow สองภาษา';

  @override
  String get developerMessageBenefits =>
      'ใช้เพื่อช่วยเคลียร์ requirement, สร้าง test cases, วิเคราะห์ความเสี่ยงของ bug, เตรียม release notes และเก็บผลลัพธ์จาก AI เพื่อกลับมาใช้งานภายหลัง';

  @override
  String get noHistory => 'ยังไม่มีประวัติการสร้างผลลัพธ์';

  @override
  String get searchHistory => 'ค้นหาประวัติ';

  @override
  String get allTemplates => 'ทุกเทมเพลต';

  @override
  String get allCategories => 'ทุกหมวดหมู่';

  @override
  String get dateRange => 'ช่วงวันที่';

  @override
  String get allDates => 'ทุกวันที่';

  @override
  String get today => 'วันนี้';

  @override
  String get last7Days => '7 วันที่ผ่านมา';

  @override
  String get last30Days => '30 วันที่ผ่านมา';

  @override
  String get noHistorySearchResults => 'ไม่พบประวัติที่ตรงกับตัวกรอง';

  @override
  String get noTemplates => 'ยังไม่มีเทมเพลต';

  @override
  String get loading => 'กำลังสร้าง...';

  @override
  String get requiredField => 'จำเป็นต้องกรอก';

  @override
  String get errorMissingApiKey =>
      'เพิ่ม API key ในหน้าตั้งค่าหรือส่ง OPENAI_API_KEY';

  @override
  String get errorGeneric => 'เกิดข้อผิดพลาด กรุณาลองใหม่';
}
