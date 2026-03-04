package com.pupptmstr.caliday

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.widget.RemoteViews

class CaliDayWidgetMediumReceiver : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
        ) {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val streak = prefs.getInt("streak", 0)
            val totalSP = prefs.getInt("totalSP", 0)
            val done = prefs.getBoolean("workoutDoneToday", false)
            val rankName = prefs.getString("rankName", "") ?: ""

            val views = RemoteViews(context.packageName, R.layout.caliday_widget_medium_layout)
            views.setTextViewText(R.id.widget_streak, "$streak")
            views.setTextViewText(R.id.widget_sp, "$totalSP SP")
            views.setTextViewText(R.id.widget_rank, rankName)
            views.setImageViewResource(
                R.id.widget_goro,
                if (done) R.drawable.goro_flex else R.drawable.goro_idle,
            )
            views.setViewVisibility(
                R.id.widget_status_row,
                if (done) View.VISIBLE else View.GONE,
            )

            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("caliday://workout"))
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
