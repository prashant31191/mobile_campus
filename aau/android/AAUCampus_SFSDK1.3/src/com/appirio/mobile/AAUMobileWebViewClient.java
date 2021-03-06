package com.appirio.mobile;


import org.apache.cordova.CordovaWebViewClient;
import org.apache.cordova.DroidGap;

import android.webkit.WebView;

public class AAUMobileWebViewClient extends CordovaWebViewClient {

	@Override
	public boolean shouldOverrideUrlLoading(WebView webView, String url) {
/*
		try {
			if(url.endsWith("mob_StudentHome?appVersion=2_1")){
				//String html = "<html><link rel=\"Stylesheet\" type=\"text/css\" href=\"file:///android_asset/jquery_mobile.css\"></link><img src=\"file:///android_asset/sports-icon.png\"/></html>";//readHtml(url);
				String x_url = url; //"https://aau--dev7.cs1.my.salesforce.com/apex/mob_StudentHome?appVersion=2_1";	
				String html = readHtml(x_url); readHtml(url)
				Log.d("AAUMobileWebViewClient",html);
				html = html.replaceAll("aaumobile://", "file:///android_asset/");
				webView.loadDataWithBaseURL("file:///android_asset/", html, "text/html", "utf-8", "");
				return true;
			} else {
				return super.shouldOverrideUrlLoading(webView, url);
			}
		} catch(Exception ex) {
			ex.printStackTrace();
			
			throw new RuntimeException(ex);
		}
	*/
		
		return super.shouldOverrideUrlLoading(webView, url);
	}

	
	
	/*
	@Override
	public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
		if(url.startsWith("aaumobile://")) {
			String resName = url.substring(12);
			
			try {
				String mimeType = "image/png";
				
				if(resName.toLowerCase().endsWith("css")) {
					mimeType = "text/css";
				}
				if(resName.toLowerCase().endsWith("html")) {
					mimeType = "text/html";
				}
				if(resName.toLowerCase().endsWith("js")) {
					mimeType = "application/javascript";
				}
				
				return new WebResourceResponse(mimeType, null, this.ctx.getAssets().open(resName));
			} catch (IOException e) {
				e.printStackTrace();
				return null;
			}
		} else {
			return super.shouldInterceptRequest(view, url);
		}
	}*/

	
	/* (non-Javadoc)
	 * @see android.webkit.WebViewClient#onLoadResource(android.webkit.WebView, java.lang.String)
	 */
	@Override
	public void onLoadResource(WebView view, String url) {
		
//		if(url.startsWith("aaumobile://")) {
//			//String resName = url.substring(12);			
//			try {
//				String mimeType = "image/png";
//				
//				if(url.toLowerCase().endsWith("html")) {
//					mimeType = "text/html";
//				}
//				if(url.toLowerCase().endsWith("js")) {
//					mimeType = "application/javascript";
//				
//					if(url.endsWith("mob_CombinedLibs_min.js")) {
//						String data = convertStreamToString(this.ctx.getAssets().open("mob_CombinedLibs_min.js"));
//						view.loadDataWithBaseURL("file:///android_asset", data, mimeType, "UTF-8", null);
//						return;
//					}
//					if(url.toLowerCase().endsWith("cordova.js")) {				
//						String data = convertStreamToString(this.ctx.getAssets().open("cordova.js"));
//						view.loadDataWithBaseURL("file:///android_asset", data, mimeType, "UTF-8", null);
//						return;
//					}
//				
//				}
//								
//			} catch (Exception e) {
//				e.printStackTrace();
//				return;
//			}
//		}

		//if (url.endsWith("mob_StudentHome?appVersion=2_1")){
			//ext_html = readHtml(url);
		//	save_url = url;
		//}
		
		super.onLoadResource(view, url);
	}

	public AAUMobileWebViewClient(DroidGap ctx) {
		super(ctx);
	}
	
	/**
	 * methods bellow commented by A.I. private and not used
	 * @param is
	 * @return
	 * @throws Exception
	 *
	private static String convertStreamToString(InputStream is) throws Exception {
	    BufferedReader reader = new BufferedReader(new InputStreamReader(is));
	    StringBuilder sb = new StringBuilder();
	    String line = null;

	    while ((line = reader.readLine()) != null) {
	        sb.append(line);
	    }

	    is.close();

	    return sb.toString();
	}
	
	private String readHtml(String remoteUrl) {
	    String out = "";
	    BufferedReader in = null;
	    try {
	        URL url = new URL(remoteUrl);
	        in = new BufferedReader(new InputStreamReader(url.openStream()));
	        String str;
	        while ((str = in.readLine()) != null) {
	            out += str;
	        }
	    } catch (MalformedURLException e) { 
	    } catch (IOException e) { 
	    } finally {
	        if (in != null) {
	            try {
	                in.close();
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        }
	    }
	    return out;
	}
	**/	
}
