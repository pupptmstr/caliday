package com.pupptmstr.treniday

import android.content.Context
import android.content.SharedPreferences
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.temporal.ChronoUnit

/**
 * What the app last wrote for the widgets (`WidgetSnapshot.build` in
 * lib/core/services/widget_snapshot.dart). Every text is the app's, in its
 * language; the widgets add none of their own.
 */
class Snapshot(prefs: SharedPreferences) {
    private val all = prefs.all

    private fun text(key: String) = all[key] as? String ?: ""
    private fun int(key: String) = (all[key] as? Number)?.toInt() ?: 0
    private fun lines(key: String) = text(key).split('\n').filter { it.isNotEmpty() }.map {
        val parts = it.split('\t', limit = 2)
        parts[0] to parts.getOrElse(1) { "" }
    }

    val day = text("day")
    val streak = int("streak")
    val freezes = int("freezes")
    val lastWorkoutDay = text("lastWorkoutDay")
    val trainedDays = text("trainedDays").split(',').filter { it.isNotEmpty() }.toSet()
    val streakText = text("streakText")
    val streakZeroText = text("streakZeroText")
    val weekdays = text("weekdays").split(',').filter { it.isNotEmpty() }
    val totalSP = int("totalSP")
    val spToday = int("spToday")
    val rankName = text("rankName")
    val rankProgress = int("rankProgress")
    val rankGoal = text("rankGoal")
    val courseName = text("courseName")
    val planCount = int("planCount")
    val planSummary = text("planSummary")
    val planLines = lines("planLines")
    val growthLines = lines("growthLines")
    val todayTitle = text("todayTitle")
    val streakTitle = text("streakTitle")
    val rankTitle = text("rankTitle")
    val growthTitle = text("growthTitle")
    val trainLabel = text("trainLabel")
    val doneLabel = text("doneLabel")
    val doneTitle = text("doneTitle")
    val spTodayText = text("spTodayText")

    companion object {
        fun read(context: Context) =
            Snapshot(context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE))
    }
}

/**
 * The snapshot as seen at [now]: the app's rules of the day, mirrored from
 * Dart (`HomeData.displayStreak`, `goroExpressionProvider`) and in
 * `WidgetState.swift` — change all three together.
 */
class WidgetEntry(val snap: Snapshot, val now: LocalDateTime = LocalDateTime.now()) {
    private val today: LocalDate = now.toLocalDate()
    private val todayKey = today.toString()

    /** The plan, the SP and the growth of the snapshot are today's. */
    val isSnapshotDay = snap.day == todayKey

    /** Any workout today. */
    val done = snap.trainedDays.contains(todayKey)

    /** Days since the last workout; -1 when there has been none. */
    private val daysSinceWorkout =
        if (snap.lastWorkoutDay.isEmpty()) -1
        else ChronoUnit.DAYS.between(LocalDate.parse(snap.lastWorkoutDay), today).toInt()

    /** The streak as the app shows it: kept for a day without training, two with a freeze left. */
    val streak =
        if (daysSinceWorkout <= 1 || (daysSinceWorkout == 2 && snap.freezes > 0)) snap.streak else 0

    /** "12 days" for the shown streak. */
    val streakText = if (streak == snap.streak) snap.streakText else snap.streakZeroText

    /** The words after the number in [streakText] ("days"), for the big number. */
    val streakUnit = streak.toString().let { n ->
        if (streakText.startsWith(n)) streakText.substring(n.length).trim() else streakText
    }

    /** "Done · +45 SP"; just "Done" for a day without SP (a warm-up only). */
    val doneShort = if (snap.spToday > 0) "${snap.doneLabel} · +${snap.spToday} SP" else snap.doneLabel

    /**
     * Goro's face: asleep 23–6, happy after a workout, angry from 22 with a
     * streak to lose, sad from 20, supportive after two days without one.
     */
    val mood = when {
        now.hour >= 23 || now.hour < 6 -> "sleeping"
        done -> "happy"
        now.hour >= 22 && streak > 0 -> "angry"
        now.hour >= 20 -> "sad"
        daysSinceWorkout >= 2 -> "supportive"
        else -> "happy"
    }

    val face = FACES.getValue(mood)

    /** Goro's pose of the day; the Rank widget takes another one of the same day ([shift]). */
    fun pose(shift: Int = 0): Int {
        val n = ChronoUnit.DAYS.between(LocalDate.of(2024, 1, 1), today).toInt() + shift
        return POSES[Math.floorMod(n, POSES.size)]
    }

    /** The pose of the day, or Goro flexing once the day's workout is done. */
    val todayArt get() = if (done) R.drawable.goro_flex else pose()

    /** The week of today, Monday first: (letter, trained, is today). */
    val week: List<Triple<String, Boolean, Boolean>> =
        today.minusDays((today.dayOfWeek.value - 1).toLong()).let { monday ->
            (0 until 7).map { i ->
                val key = monday.plusDays(i.toLong()).toString()
                Triple(snap.weekdays.getOrElse(i) { "" }, snap.trainedDays.contains(key), key == todayKey)
            }
        }

    companion object {
        fun now(context: Context) = WidgetEntry(Snapshot.read(context))

        private val FACES = mapOf(
            "happy" to R.drawable.goro_face_happy,
            "sad" to R.drawable.goro_face_sad,
            "angry" to R.drawable.goro_face_angry,
            "sleeping" to R.drawable.goro_face_sleeping,
            "supportive" to R.drawable.goro_face_supportive,
        )

        // The order of WidgetState.swift: the same pose on both platforms.
        private val POSES = listOf(
            R.drawable.goro_pose_one_arm_handstand,
            R.drawable.goro_pose_flag,
            R.drawable.goro_pose_one_arm_pullup,
            R.drawable.goro_pose_barbell,
            R.drawable.goro_pose_lotus,
            R.drawable.goro_pose_banana,
        )
    }
}
