package com.iqonic.streamit_flutter

import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.Log
import android.view.MenuItem
import android.view.View
import android.webkit.ValueCallback
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_streamit_web_view.*

class WebViewActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_streamit_web_view)

        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.setHomeAsUpIndicator(R.drawable.back_button)
        supportActionBar?.setIcon(R.drawable.back_button)
        supportActionBar?.setBackgroundDrawable(ColorDrawable(Color.parseColor("#141414")))

        val url = intent.getStringExtra("url")!!
        val username: String = intent.getStringExtra("username")!!
        val password: String = intent.getStringExtra("password")!!
        var isLoggedIn: Boolean = intent.getBooleanExtra("isLoggedIn", false)

        Log.d("url", url)
        
        webView.setBackgroundColor(Color.parseColor("#000000"))

        webView.clearCache(true)

        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                view?.loadUrl(url!!)
                return true
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                Log.d("onPageFinished", url!!)
                progressBar.visibility = View.GONE

                if (!isLoggedIn && url.contains("_wpnonce")) {
                    webView.evaluateJavascript("document.getElementById('pms_login').submit()") {
                        //
                    }
                }

                if (isLoggedIn) {

                    webView.evaluateJavascript("document.getElementById('user_login').value ='${username}'", ValueCallback {
                        //
                    })
                    webView.evaluateJavascript("document.getElementById('user_pass').value = '${password}'") {
                        //
                    }

                    webView.evaluateJavascript("document.getElementById('pms_login').submit()") {
                        //
                    }
                    isLoggedIn = false
                }
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                Log.d("onPageFinished", url!!)
                progressBar.visibility = View.VISIBLE
            }
        }

        webView.settings.javaScriptEnabled = true
        webView.settings.allowFileAccess = true;
        webView.settings.allowContentAccess = true;

        webView.loadUrl(url)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle presses on the action bar menu items
        when (item.itemId) {
            android.R.id.home -> {
                onBackPressed()
                return true
            }
        }
        return super.onOptionsItemSelected(item)
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.evaluateJavascript(
                    "var check = document.getElementsByClassName('pms-account-navigation-link--logout');\n" +
                            "if (check.length > 0) {\n" +
                            "// elements with class \"snake--mobile\" exist\n" +
                            "document.querySelector('.pms-account-navigation-link--logout a').click();\n" +
                            "}", ValueCallback {})


            webView.goBack()
        } else {
            webView.evaluateJavascript(
                    "var check = document.getElementsByClassName('pms-account-navigation-link--logout');\n" +
                            "if (check.length > 0) {\n" +
                            "    // elements with class \"snake--mobile\" exist\n" +
                            "document.querySelector('.pms-account-navigation-link--logout a').click();\n" +
                            "}", ValueCallback {})


            webView.clearCache(true)
            webView.clearFormData()
            webView.clearHistory()
            webView.clearMatches()
            webView.clearSslPreferences()
            super.onBackPressed()
        }
    }


}