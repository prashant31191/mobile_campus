public with sharing class mob_DeviceDetection {

    public String phonegapJS {get;set;} 
    public String osVersion {get;set;}
    public Decimal appVersion {get;set;}
    public String userAgent {get;set;}
    public boolean hasNativeResources {get;set;}
    public boolean hasNativeMenu{get;set;}
    public boolean hasNativeMap{get;set;}
    public boolean isMinimum{get;set;}
    public boolean isAndroid {get;set;}
    public boolean isMobile {get;set;}
    public boolean testRegexPattern{get;set;}
    
    public String userName {get;set;}
    public String userPicUrl {get;set;}
    public String userProfile {get;set;}

    public mob_DeviceDetection() {
    	userName = UserInfo.getName();
    	User usr = [Select u.SmallPhotoUrl, u.PortalRole, u.FullPhotoUrl, u.Division From User u where id = :UserInfo.getUserId() ];
    	userPicUrl = usr.FullPhotoUrl ;//+ '?oauth_token=' + UserInfo.getSessionId(); 
    	
         hasNativeMenu = false;
         hasNativeResources = false;
         hasNativeMap = false;
         isMinimum = false;
         testRegexPattern = false;
         userAgent = System.currentPageReference().getHeaders().get('User-Agent');
         userAgent = userAgent.toLowerCase();
		 isMobile = userAgent.contains('mobile');
         String appVersionString = ApexPages.currentPage().getParameters().get('appVersion');
         if(appVersionString == null){
         	appVersion = 1.0;
         } else{
         	appVersion = Decimal.valueOf(appVersionString.replace('_', '.'));
         }
         mob_Student__c customSettings = mob_Student__c.getOrgDefaults();
         if(appVersion >= customSettings.Minimum_Version__c || isMobile == false){
         	isMinimum = true;
         }
         isAndroid = false; 
         string testString = 'Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30';
          //testString = 'Mozilla/5.0 (Linux; U; Android 2.3.3; de-ch; HTC Desire Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';
         Pattern pat = Pattern.compile('android [3-9]');
                        Matcher matchr = pat.matcher(testString.toLowerCase());
                        if (matchr.find()) {
                            testRegexPattern = true;
                        }
         
         if(userAgent.contains('android')){
            isAndroid = true;
            phonegapJS = 'phonegap_android_min';
            if(appVersion != null){
                if(appVersion >= 1.2){
                    if(appVersion >= 1.3){
                        Pattern MyPattern = Pattern.compile('android [3-9]');
                        Matcher MyMatcher = MyPattern.matcher(userAgent);
                        if (MyMatcher.find()) {
                            //hasNativeResources = true;
                        }
                        hasNativeMenu = true;
                    }
                    if(appVersion >= 2.1){
                        hasNativeMap = true;
                    }
                    phonegapJS += '_1_2';
                }
            }
            phonegapJS += '.js';
         }else{
            phonegapJS = 'phonegap_min';
            if(appVersion != null){
                if(appVersion >= 1.2){
                    if(appVersion >= 1.3){
                        hasNativeMenu = true;
                        hasNativeResources = true;
                        hasNativeMap = true;
                    }
                    phonegapJS += '_1_2';
                }
            }
            phonegapJS += '.js';
         }
         
         osVersion = 'PC';
       if(userAgent.contains('Android') || userAgent.contains( 'iPhone' )|| userAgent.contains('iPod') || userAgent.contains( 'iPad') ){
         osVersion =  userAgent.split(' ')[1];
         
         if(osVersion.contains( 'iPhone' )|| osVersion.contains('iPod') || osVersion.contains( 'iPad') ){
            osVersion = 'iOS';
         }
         osVersion += ' v' + userAgent.split(' ')[2].split('/')[1];
       }
    }
}