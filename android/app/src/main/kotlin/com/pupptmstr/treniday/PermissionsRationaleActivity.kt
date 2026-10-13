package com.pupptmstr.treniday

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Bundle

// Health Connect opens this when the user taps TreniDay's privacy policy on its
// permissions screen (ACTION_SHOW_PERMISSIONS_RATIONALE up to Android 13, the
// ViewPermissionUsageActivity alias from Android 14). It hands the policy to the
// browser and closes; the app itself does not start.
class PermissionsRationaleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(PRIVACY_POLICY_URL)))
        } catch (_: ActivityNotFoundException) {
            // No browser: nothing to show the page in.
        }
        finish()
    }

    companion object {
        const val PRIVACY_POLICY_URL = "https://pupptmstr.github.io/treniday/PRIVACY_POLICY"
    }
}
