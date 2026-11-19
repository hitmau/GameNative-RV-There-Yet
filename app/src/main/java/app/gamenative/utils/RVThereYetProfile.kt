package app.gamenative.utils

import java.io.File

/** Local-import profile for the Windows release of RV There Yet?. */
object RVThereYetProfile {
    const val DISPLAY_NAME = "RV There Yet?"
    const val EXECUTABLE_RELATIVE_PATH = "Ride/Binaries/Win64/Ride-Win64-Shipping.exe"

    data class Install(val executableRelativePath: String)

    /**
     * Recognizes the complete Steam install root without contacting Steam.
     * Requiring both the Shipping executable and Unreal IoStore content avoids
     * mistaking the small top-level Ride.exe bootstrapper for the game.
     */
    fun detect(gameDirectory: File): Install? {
        if (!gameDirectory.isDirectory) return null

        val executable = File(gameDirectory, EXECUTABLE_RELATIVE_PATH)
        val paksDirectory = File(gameDirectory, "Ride/Content/Paks")
        val engineBinaries = File(gameDirectory, "Engine/Binaries")
        val hasUnrealContent = paksDirectory.listFiles()?.any { file ->
            file.isFile && file.length() > 0L &&
                (file.extension.equals("ucas", ignoreCase = true) ||
                    file.extension.equals("utoc", ignoreCase = true))
        } == true

        if (!executable.isFile || !engineBinaries.isDirectory || !hasUnrealContent) return null
        return Install(EXECUTABLE_RELATIVE_PATH)
    }

    fun displayName(gameDirectory: File, fallback: String = gameDirectory.name): String =
        if (detect(gameDirectory) != null) DISPLAY_NAME else fallback
}
