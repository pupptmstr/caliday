package com.pupptmstr.treniday

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.SizeF
import android.view.View
import android.widget.RemoteViews

// The home-screen widgets (agreed with the owner 2026-10-12): Today, Goro,
// Streak and Rank. What they show comes from the app (WidgetState.kt reads
// it); the providers are listed in WidgetService.androidProviders.
// TreniDayWidgetReceiver is the Today widget.

/** Today: the plan of the day, the streak and the week; 2×2 up to 4×4. */
class TreniDayWidgetReceiver : SizedWidget() {
    override fun views(context: Context, entry: WidgetEntry, size: Size) = when (size) {
        Size.SMALL -> WidgetViews.todaySmall(context, entry)
        Size.MEDIUM -> WidgetViews.todayMedium(context, entry)
        Size.LARGE -> WidgetViews.todayLarge(context, entry)
    }
}

/** Goro's face by the mood of the day. */
class GoroWidgetReceiver : SizedWidget() {
    override fun views(context: Context, entry: WidgetEntry, size: Size) = WidgetViews.goro(context, entry)
}

/** The streak on a dark ember, the freezes and the week. */
class StreakWidgetReceiver : SizedWidget() {
    override fun views(context: Context, entry: WidgetEntry, size: Size) = WidgetViews.streak(context, entry)
}

/** The rank, SP and the way to the next one; 2×2 or 4×2. */
class RankWidgetReceiver : SizedWidget() {
    override fun views(context: Context, entry: WidgetEntry, size: Size) =
        if (size == Size.SMALL) WidgetViews.rankSmall(context, entry) else WidgetViews.rankMedium(context, entry)
}

/**
 * A widget whose layout follows its size: on Android 12+ the launcher picks
 * from all three as the widget is resized, before that the size the launcher
 * reports picks one (portrait: the minimum width, the maximum height).
 */
abstract class SizedWidget : AppWidgetProvider() {
    enum class Size { SMALL, MEDIUM, LARGE }

    abstract fun views(context: Context, entry: WidgetEntry, size: Size): RemoteViews

    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        val entry = WidgetEntry.now(context)
        for (id in ids) update(context, manager, id, entry)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context, manager: AppWidgetManager, id: Int, options: Bundle,
    ) = update(context, manager, id, WidgetEntry.now(context))

    private fun update(context: Context, manager: AppWidgetManager, id: Int, entry: WidgetEntry) {
        val views = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            RemoteViews(mapOf(
                SizeF(100f, 100f) to views(context, entry, Size.SMALL),
                SizeF(MEDIUM_WIDTH, 100f) to views(context, entry, Size.MEDIUM),
                SizeF(MEDIUM_WIDTH, LARGE_HEIGHT) to views(context, entry, Size.LARGE),
            ))
        } else {
            val options = manager.getAppWidgetOptions(id)
            val width = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
            val height = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT)
            views(context, entry, when {
                width >= MEDIUM_WIDTH && height >= LARGE_HEIGHT -> Size.LARGE
                width >= MEDIUM_WIDTH -> Size.MEDIUM
                else -> Size.SMALL
            })
        }
        manager.updateAppWidget(id, views)
    }

    private companion object {
        const val MEDIUM_WIDTH = 250f
        const val LARGE_HEIGHT = 280f
    }
}

private object WidgetViews {
    private const val VISIBLE = View.VISIBLE
    private const val GONE = View.GONE

    private fun views(context: Context, layout: Int, link: String) =
        RemoteViews(context.packageName, layout).apply {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(link)).setPackage(context.packageName)
            setOnClickPendingIntent(
                R.id.widget_root,
                PendingIntent.getActivity(
                    context, link.hashCode(), intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                ),
            )
        }

    private fun RemoteViews.show(id: Int, visible: Boolean) = setViewVisibility(id, if (visible) VISIBLE else GONE)

    private fun RemoteViews.chips(entry: WidgetEntry) {
        setTextViewText(R.id.chip_streak, "${entry.streak}")
        setTextViewText(R.id.chip_sp, "${entry.snap.totalSP}")
        setTextViewText(R.id.chip_freeze, "${entry.snap.freezes}")
        show(R.id.chip_freeze, entry.snap.freezes > 0)
    }

    private val DOTS = intArrayOf(
        R.id.week_dot_0, R.id.week_dot_1, R.id.week_dot_2, R.id.week_dot_3,
        R.id.week_dot_4, R.id.week_dot_5, R.id.week_dot_6,
    )
    private val DAYS = intArrayOf(
        R.id.week_day_0, R.id.week_day_1, R.id.week_day_2, R.id.week_day_3,
        R.id.week_day_4, R.id.week_day_5, R.id.week_day_6,
    )

    private fun RemoteViews.week(entry: WidgetEntry, dark: Boolean = false) {
        entry.week.forEachIndexed { i, (letter, trained, today) ->
            setTextViewText(DAYS[i], letter)
            setImageViewResource(DOTS[i], when {
                trained -> if (today) R.drawable.widget_dot_on_today else R.drawable.widget_dot_on
                dark -> if (today) R.drawable.widget_dot_off_dark_today else R.drawable.widget_dot_off_dark
                else -> if (today) R.drawable.widget_dot_off_today else R.drawable.widget_dot_off
            })
        }
    }

    private fun RemoteViews.rank(entry: WidgetEntry) {
        setTextViewText(R.id.rank_title, entry.snap.rankTitle)
        setTextViewText(R.id.rank_name, entry.snap.rankName)
        setTextViewText(R.id.rank_sp, "${entry.snap.totalSP} SP")
        setTextViewText(R.id.rank_goal, entry.snap.rankGoal)
        setProgressBar(R.id.rank_bar, 1000, entry.snap.rankProgress, false)
    }

    /** The plan only while the snapshot is of today and has one. */
    private fun hasPlan(entry: WidgetEntry) = entry.isSnapshotDay && entry.snap.planCount > 0

    fun todaySmall(context: Context, entry: WidgetEntry) =
        views(context, R.layout.widget_today_small, "treniday://workout").apply {
            setImageViewResource(R.id.widget_goro, entry.todayArt)
            chips(entry)
            show(R.id.caption_done, entry.done)
            setTextViewText(R.id.caption_done_text, entry.doneShort)
            show(R.id.caption_plan, !entry.done)
            setTextViewText(R.id.caption_plan, if (hasPlan(entry)) entry.snap.planSummary else entry.snap.trainLabel)
        }

    fun todayMedium(context: Context, entry: WidgetEntry) =
        views(context, R.layout.widget_today_medium, "treniday://workout").apply {
            setImageViewResource(R.id.widget_goro, entry.todayArt)
            chips(entry)
            setTextViewText(R.id.streak_big, "${entry.streak}")
            setTextViewText(R.id.streak_unit, entry.streakUnit)
            setTextViewText(R.id.sp_rank, "${entry.snap.totalSP} SP · ${entry.snap.rankName}")
            week(entry)
            show(R.id.caption_done, entry.done)
            setTextViewText(R.id.caption_done_text, entry.doneShort)
            show(R.id.plan_pill, !entry.done && hasPlan(entry))
            setTextViewText(R.id.plan_pill, entry.snap.planSummary)
            show(R.id.caption_plan, !entry.done && !hasPlan(entry))
            setTextViewText(R.id.caption_plan, entry.snap.trainLabel)
        }

    private val PLAN_ROWS = intArrayOf(R.id.plan_row_0, R.id.plan_row_1, R.id.plan_row_2, R.id.plan_row_3, R.id.plan_row_4)
    private val PLAN_NAMES = intArrayOf(R.id.plan_name_0, R.id.plan_name_1, R.id.plan_name_2, R.id.plan_name_3, R.id.plan_name_4)
    private val PLAN_VALUES = intArrayOf(R.id.plan_value_0, R.id.plan_value_1, R.id.plan_value_2, R.id.plan_value_3, R.id.plan_value_4)
    private val GROWTH_ROWS = intArrayOf(R.id.growth_row_0, R.id.growth_row_1, R.id.growth_row_2, R.id.growth_row_3)
    private val GROWTH_NAMES = intArrayOf(R.id.growth_name_0, R.id.growth_name_1, R.id.growth_name_2, R.id.growth_name_3)
    private val GROWTH_VALUES = intArrayOf(R.id.growth_value_0, R.id.growth_value_1, R.id.growth_value_2, R.id.growth_value_3)

    private fun RemoteViews.lines(lines: List<Pair<String, String>>, rows: IntArray, names: IntArray, values: IntArray) {
        rows.forEachIndexed { i, row ->
            val line = lines.getOrNull(i)
            show(row, line != null)
            if (line != null) {
                setTextViewText(names[i], line.first)
                setTextViewText(values[i], line.second)
            }
        }
    }

    fun todayLarge(context: Context, entry: WidgetEntry) =
        views(context, R.layout.widget_today_large, "treniday://workout").apply {
            val s = entry.snap
            setImageViewResource(R.id.widget_goro, entry.todayArt)
            setTextViewText(R.id.course_name, s.courseName)
            setTextViewText(R.id.today_title, s.todayTitle)
            chips(entry)
            week(entry)
            show(R.id.done_block, entry.done)
            setTextViewText(R.id.done_title, s.doneTitle)
            show(R.id.sp_today, entry.isSnapshotDay && s.spToday > 0)
            setTextViewText(R.id.sp_today, s.spTodayText)
            val growth = if (entry.isSnapshotDay) s.growthLines else emptyList()
            show(R.id.growth_title, growth.isNotEmpty())
            setTextViewText(R.id.growth_title, s.growthTitle)
            lines(growth, GROWTH_ROWS, GROWTH_NAMES, GROWTH_VALUES)
            show(R.id.plan_block, !entry.done && hasPlan(entry))
            setTextViewText(R.id.plan_summary, s.planSummary)
            lines(s.planLines, PLAN_ROWS, PLAN_NAMES, PLAN_VALUES)
            show(R.id.plan_more, s.planCount > PLAN_ROWS.size)
            setTextViewText(R.id.plan_more, "+${s.planCount - PLAN_ROWS.size}")
            show(R.id.train_label, !entry.done && !hasPlan(entry))
            setTextViewText(R.id.train_label, s.trainLabel)
            rank(entry)
        }

    fun goro(context: Context, entry: WidgetEntry) =
        views(context, R.layout.widget_goro, "treniday://home").apply {
            setImageViewResource(R.id.widget_goro, entry.face)
            setInt(
                R.id.widget_root, "setBackgroundResource",
                if (entry.mood == "sleeping") R.drawable.widget_bg_night else R.drawable.widget_bg_brand,
            )
            chips(entry)
        }

    fun streak(context: Context, entry: WidgetEntry) =
        views(context, R.layout.widget_streak, "treniday://calendar").apply {
            setTextViewText(R.id.streak_title, entry.snap.streakTitle)
            listOf(R.id.snow_0, R.id.snow_1, R.id.snow_2).forEachIndexed { i, id ->
                setInt(id, "setImageAlpha", if (i < entry.snap.freezes) 255 else 71)
            }
            setTextViewText(R.id.streak_number, "${entry.streak}")
            setTextViewText(R.id.streak_unit, entry.streakUnit)
            week(entry, dark = true)
        }

    fun rankSmall(context: Context, entry: WidgetEntry) =
        views(context, R.layout.widget_rank_small, "treniday://profile").apply {
            setImageViewResource(R.id.widget_goro, entry.pose(shift = 3))
            rank(entry)
        }

    fun rankMedium(context: Context, entry: WidgetEntry) =
        views(context, R.layout.widget_rank_medium, "treniday://profile").apply {
            setImageViewResource(R.id.widget_goro, entry.pose(shift = 3))
            rank(entry)
        }
}
