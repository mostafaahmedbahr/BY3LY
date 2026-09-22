
import 'package:by3ly/features/search/presentation/view_model/search_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/all_products_search_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repos/search_repos.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit(this.searchRepos) : super(SearchInitState());

  static SearchCubit get(context) => BlocProvider.of(context);


  CategoryModel? selectedCategory;
  String? selectedSubCategory;

    selectCategory(CategoryModel? category) {
      selectedCategory = category;
      selectedSubCategory = null;
      print(selectedCategory);
      print(selectedCategory!.id);
    emit(SelectCategoryState());
  }

    selectSubCategory(String? selectedSubCategory1) {
      selectedSubCategory = selectedSubCategory1;
      print(selectedSubCategory);
    emit(SelectSubCategoryState());
  }

  List<CategoryModel> categoriesAndSubCategories = [
    CategoryModel(id: 1, name: 'إلكترونيات',   image:  "assets/images/Processor.svg",subCategories: [
      'هواتف',
      'لابتوبات',
      'أجهزة لوحية',
      'تلفزيونات',
      'كاميرات',
      'ملحقات الكمبيوتر',
      'أجهزة الألعاب',
    ]),
    CategoryModel(id: 2, name: 'ملابس',   image:  "assets/images/Processor.svg",subCategories: [
      'ملابس رجالية',
      'ملابس نسائية',
      'ملابس أطفال',
      'أحذية',
      'إكسسوارات',
    ]),
    CategoryModel(id: 3, name: 'أحذية',   image:  "assets/images/Processor.svg",subCategories: [
      'أحذية رجالية',
      'أحذية نسائية',
      'أحذية أطفال',
    ]),
    CategoryModel(id: 4, name: 'أدوات منزلية',   image:  "assets/images/Processor.svg",subCategories: [
      'أدوات المطبخ',
      'أواني الطهي',
      'تنظيف المنزل',
      'أدوات التزيين',
    ]),
    CategoryModel(id: 5, name: 'أثاث',   image:  "assets/images/Processor.svg",subCategories: [
      'أثاث غرفة المعيشة',
      'أثاث غرفة النوم',
      'أثاث المطبخ',
      'أثاث المكتب',
    ]),
    CategoryModel(id: 6, name: 'جمال وعناية شخصية',   image:  "assets/images/Processor.svg",subCategories: [
      'منتجات العناية بالبشرة',
      'منتجات العناية بالشعر',
      'مستحضرات التجميل',
      'عطور',
    ]),
    CategoryModel(id: 7, name: 'كتب',   image:  "assets/images/Processor.svg",subCategories: [
      'كتب تعليمية',
      'روايات',
      'كتب أطفال',
      'مجلات',
    ]),
    CategoryModel(id: 8, name: 'ألعاب',   image:  "assets/images/Processor.svg",subCategories: [
      'ألعاب تعليمية',
      'ألعاب للأطفال',
      'ألعاب خارجية',
    ]),
    CategoryModel(id: 9, name: 'رياضة',   image:  "assets/images/Processor.svg",subCategories: [
      'معدات اللياقة البدنية',
      'ملابس رياضية',
      'أحذية رياضية',
      'معدات رياضية',
    ]),
    CategoryModel(id: 10, name: 'مستلزمات الحيوانات الأليفة',   image:  "assets/images/Processor.svg",subCategories: [
      'أغذية الحيوانات',
      'إكسسوارات الحيوانات',
      'ألعاب الحيوانات',
    ]),
    CategoryModel(id: 11, name: 'مستلزمات الأطفال',   image:  "assets/images/Processor.svg",subCategories: [
      'ملابس الأطفال',
      'ألعاب الأطفال',
      'عربات الأطفال',
    ]),
    CategoryModel(id: 12, name: 'مواد غذائية',   image:  "assets/images/Processor.svg",subCategories: [
      'خضروات وفواكه',
      'لحوم ودواجن',
      'منتجات الألبان',
      'بقالة',
    ]),
    CategoryModel(id: 13, name: 'معدات ومستلزمات السيارات',   image:  "assets/images/Processor.svg",subCategories: [
      'قطع غيار السيارات',
      'إكسسوارات السيارات',
      'منتجات العناية بالسيارات',
    ]),
    CategoryModel(id: 14, name: 'منتجات صحية',   image:  "assets/images/Processor.svg",subCategories: [
      'مكملات غذائية',
      'معدات طبية',
      'أدوية',
    ]),
    CategoryModel(id: 15, name: 'أدوات مكتبية',   image:  "assets/images/Processor.svg",subCategories: [
      'أدوات الكتابة',
      'أوراق ودفاتر',
      'أدوات تنظيم المكتب',
    ]),
    CategoryModel(id: 16, name: 'معدات صناعية',   image:  "assets/images/Processor.svg",subCategories: [
      'معدات البناء',
      'معدات الزراعة',
      'معدات الورش',
    ]),
    CategoryModel(id: 17, name: 'مستلزمات السفر',   image:  "assets/images/Processor.svg",subCategories: [
      'حقائب السفر',
      'مستلزمات التخييم',
      'إكسسوارات السفر',
    ]),
    CategoryModel(id: 18, name: 'مجوهرات وساعات',   image:  "assets/images/Processor.svg",subCategories: [
      'مجوهرات نسائية',
      'مجوهرات رجالية',
      'ساعات',
    ]),
    CategoryModel(id: 19, name: 'معدات التصوير',   image:  "assets/images/Processor.svg",subCategories: [
      'كاميرات',
      'عدسات',
      'ملحقات التصوير',
    ]),
    CategoryModel(id: 20, name: 'أدوات الموسيقى',   image:  "assets/images/Processor.svg",subCategories: [
      'آلات موسيقية',
      'إكسسوارات موسيقية',
      'معدات الصوت',
    ]),
    CategoryModel(id: 21, name: 'منتجات يدوية',   image:  "assets/images/Processor.svg",subCategories: [
      'مشغولات يدوية',
      'حرف يدوية',
      'منتجات تقليدية',
    ]),
    CategoryModel(id: 22, name: 'مستلزمات الحفلات',   image:  "assets/images/Processor.svg",subCategories: [
      'ديكورات الحفلات',
      'ملابس الحفلات',
      'إكسسوارات الحفلات',
    ]),
    CategoryModel(id: 23, name: 'ألعاب الفيديو',   image:  "assets/images/Processor.svg",subCategories: [
      'ألعاب الكمبيوتر',
      'ألعاب الأجهزة المحمولة',
      'ملحقات الألعاب',
    ]),
    CategoryModel(id: 24, name: 'الأجهزة المنزلية',   image:  "assets/images/Processor.svg",subCategories: [
      'ثلاجات',
      'غسالات',
      'أفران',
      'مكنسات كهربائية',
    ]),
  ];




  List<String> shippingOptions = ['شحن مجاني', 'تكلفة الشحن' , 'كلاهما'];
  String? selectedShippingOption;

  void selectShippingOption(String? newValue) {
    selectedShippingOption = newValue;
    emit(SelectShippingOptionState());
  }


  static const Map<String, List<String>> governoratesAndCenters = {
    'القاهرة': ['القاهرة', 'المعادى', 'عين شمس', 'حلوان', 'مدينة نصر', 'الزمالك', 'مصر الجديدة'],
    'الجيزة': ['الجيزة', 'الدقى', 'العجوزة', 'الهرم', '6 أكتوبر', 'الشيخ زايد', 'البدرشين', 'العياط'],
    'الإسكندرية': ['الإسكندرية', 'برج العرب', 'العجمى', 'الرمل', 'المنتزه'],
    'البحيرة': ['دمنهور', 'كفر الدوار', 'رشيد', 'إدكو', 'المحمودية', 'إيتاي البارود'],
    'المنوفية': ['شبين الكوم', 'السادات', 'منوف', 'الباجور', 'تلا', 'الشهداء'],
    'الدقهلية': ['المنصورة', 'طلخا', 'ميت غمر', 'دكرنس', 'نبروه', 'بلقاس'],
    'الغربية': ['طنطا', 'المحلة الكبرى', 'كفر الزيات', 'زفتى', 'قطور', 'بسيون'],
    'الشرقية': ['الزقازيق', 'العاشر من رمضان', 'بلبيس', 'منيا القمح', 'فاقوس', 'أبو حماد'],
    'كفر الشيخ': ['كفر الشيخ', 'دسوق', 'فوه', 'بلطيم', 'مطوبس'],
    'بورسعيد': ['بورسعيد', 'بورفؤاد'],
    'الإسماعيلية': ['الإسماعيلية', 'القنطرة شرق', 'القنطرة غرب', 'فايد', 'التل الكبير'],
    'السويس': ['السويس', 'عتاقة', 'الأربعين'],
    'مطروح': ['مرسى مطروح', 'الحمام', 'الضبعة', 'سيوة'],
    'جنوب سيناء': ['شرم الشيخ', 'دهب', 'نويبع', 'طابا', 'رأس سدر', 'طور سيناء'],
    'شمال سيناء': ['العريش', 'رفح', 'الشيخ زويد', 'بئر العبد'],
    'بني سويف': ['بني سويف', 'الواسطى', 'ناصر', 'إهناسيا', 'ببا', 'سمسطا', 'الفشن'],
    'الفيوم': ['الفيوم', 'سنورس', 'إطسا', 'طامية', 'يوسف الصديق'],
    'المنيا': ['المنيا', 'العدوة', 'مغاغة', 'بني مزار', 'مطاي', 'سمالوط', 'أبو قرقاص'],
    'أسيوط': ['أسيوط', 'ديروط', 'منفلوط', 'القوصية', 'أبو تيج', 'الغنايم'],
    'سوهاج': ['سوهاج', 'جرجا', 'أخميم', 'البلينا', 'المراغة', 'طما', 'طهطا'],
    'قنا': ['قنا', 'نجع حمادي', 'قفط', 'قوص', 'نقادة'],
    'الأقصر': ['الأقصر', 'إسنا', 'أرمنت', 'البياضية'],
    'أسوان': ['أسوان', 'دراو', 'كوم أمبو', 'إدفو', 'نصر النوبة'],
    'البحر الأحمر': ['الغردقة', 'رأس غارب', 'سفاجا', 'القصير', 'مرسى علم'],
    'الوادي الجديد': ['الخارجة', 'الداخلة', 'الفرافرة', 'باريس', 'بلاط'],
  };

  List<String> governorates = governoratesAndCenters.keys.toList();
  String? selectedGovernorate;
  List<String> centers = [];
  String? selectedCenter;

  void loadGovernorates() {
    emit(GovernoratesLoaded(governorates, centers, selectedGovernorate, selectedCenter));
  }

  void selectGovernorate(String? governorate) {
    selectedGovernorate = governorate;
    centers = governoratesAndCenters[governorate] ?? [];
    selectedCenter = null;
    emit(GovernoratesLoaded(governorates, centers, selectedGovernorate, selectedCenter));
  }

  void selectCenter(String? center) {
    selectedCenter = center;
    emit(GovernoratesLoaded(governorates, centers, selectedGovernorate, selectedCenter));
  }



  final List<String> conditionOptions = ['جديد', 'مستعمل', 'كلاهما']; // Define options
  String? selectedConditionOption;

  selectConditionOption(String? conditionOption) {
    selectedConditionOption = conditionOption;
    print(selectedConditionOption);
    emit(SelectedConditionOptionState());
  }






  SearchRepos? searchRepos;
  AllProductsSearchModel? allProductsSearchModel;

  List<Products> allProductsForSearchList=[];
  Future<void> getAllProductsForSearch() async {
    emit(GetAllProductsForSearchLoading());
    var result = await searchRepos!.getAllProductsForSearch();
    return result.fold((failure) {
      emit(GetAllProductsForSearchError(failure.errMessage));
    }, (data) {
     if(data.status==true){
       allProductsSearchModel = data;
       allProductsForSearchList = allProductsForSearchList + allProductsSearchModel!.data!.products!;
       emit(GetAllProductsForSearchSuccess(data));
     }else{
       emit(GetAllProductsForSearchError(data.message!));
     }
    });
  }

}