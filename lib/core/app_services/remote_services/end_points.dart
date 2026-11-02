class EndPoints {
  // static const baseUrl = "https://by3li.leaderfortrans.com/api/";
  // static const baseUrl = "http://tzhab.cloudy-digital.com/api/";
  static const baseUrl = "https://by3li.axeviadigital.com/api/";
  static const viewAllCategories = "viewAllCategories";
  static const register = "register";
  static const home = "home";
  static const bestAllView = "bestAllView";
  static const login = "login";
  static const getProfileData = "getProfileData";
  static const logout = "logout";
  static const verifyCode = "verifyCode";
  static const getCities = "getCities";
  static const addLocation = "addLocation";

  /// Favourites: GET = all, POST = add, DELETE = remove.
  static const favourites = "favourites";
  static const searchProducts = "searchProducts";
  static const deleteAccount = "deleteAccount";
  static const productDetials = "productDetials";
  static const rateProduct = "rateProduct";

  /// Pause / resume the seller's own ad.
  static const pauseAd = "pauseAd";
  static const resumeAd = "resumeAd";
  static const compareProducts = "compareProducts";
  static const addCompare = "addCompare";
  static const addProduct = "addProduct";
  static const marka = "marka";
  static const models = "models";
  static const typies = "typies";
  static const makePurchase = "makePurchase";
  static const purchaseInstructions = "purchaseInstructions";
  static const myAds = "getAllAds";
  static const deleteAds = "deleteAds";
  static const addNewAds = "addNewAds";
  static const editAd = "editAds";
  static const getSubCategories = "getSubCategories";
  static const productBySubCategory = "productBySubCategory";
  static const sellerProduct = "sellerDetails";

  /// Notifications: GET list, PATCH read, DELETE remove.
  static const notifications = "notifications";
  static const notificationsReadAll = "notifications/read-all";
  static String notificationRead(String id) => "notifications/$id/read";
  static String notificationById(String id) => "notifications/$id";
  static const complaintsTypes = "complaintsTypes";
  static const addComplaint = "addComplaint";
  static const reportReasons = "reportReasons";
  static const reportAd = "reportAd";
  static const resendCode = "resendCode";
  static const updateProfile = "updateProfile";
  static const resetPassword = "resetPassword";
  static const changePassword = "changePassword";

  /// Account settings / privacy: GET = read, PATCH = update.
  static const settings = "settings";

  static const getBanners = "getBanners";
  static const products = "products";
  static const subscriptionPackages = "subscriptionPackages";
  static const subscriptions = "subscriptions";
  static const subscriptionsCheckout = "subscriptions/checkout";
  static const paymentMethods = "payment-methods";
  static const walletTopUp = "wallet/top-up";
  static const walletHistory = "wallet/history";

  /// Seller statistics: `?month=YYYY-MM`, `?date=YYYY-MM-DD`, `?page=`.
  static const statistics = "statistics";

  /// Marketplace chat: buyer <-> seller conversations.
  /// GET = list, POST = create, DELETE = hide from the current user only.
  static const conversations = "conversations";
  static const conversationsUnreadCount = "conversations/unread-count";
  static String conversationById(int id) => "conversations/$id";
  static String conversationMessages(int id) => "conversations/$id/messages";
  static String conversationRead(int id) => "conversations/$id/read";
  static String conversationMessage(int conversationId, int messageId) =>
      "conversations/$conversationId/messages/$messageId";
}
