package app.gamenative.utils

import java.io.File
import java.nio.file.Files
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class RVThereYetProfileTest {
    @Test
    fun recognizesCompleteUnrealInstallAndSelectsShippingExecutable() {
        val root = Files.createTempDirectory("rv-there-yet-profile").toFile()
        try {
            File(root, "Ride.exe").writeBytes(byteArrayOf(1))
            File(root, RVThereYetProfile.EXECUTABLE_RELATIVE_PATH)
                .apply { parentFile.mkdirs(); writeBytes(byteArrayOf(1)) }
            File(root, "Ride/Content/Paks/Ride-Windows.ucas")
                .apply { parentFile.mkdirs(); writeBytes(byteArrayOf(1)) }
            File(root, "Ride/Content/Paks/Ride-Windows.utoc").writeBytes(byteArrayOf(1))
            File(root, "Engine/Binaries/Win64").mkdirs()

            val install = RVThereYetProfile.detect(root)

            assertEquals(RVThereYetProfile.EXECUTABLE_RELATIVE_PATH, install?.executableRelativePath)
            assertEquals(
                RVThereYetProfile.EXECUTABLE_RELATIVE_PATH,
                CustomGameScanner.findUniqueExeRelativeToFolder(root),
            )
            assertEquals(RVThereYetProfile.DISPLAY_NAME, RVThereYetProfile.displayName(root))
        } finally {
            root.deleteRecursively()
        }
    }

    @Test
    fun doesNotRecognizeBootstrapperWithoutGameContent() {
        val root = Files.createTempDirectory("rv-there-yet-incomplete").toFile()
        try {
            File(root, "Ride.exe").writeBytes(byteArrayOf(1))

            assertNull(RVThereYetProfile.detect(root))
            assertEquals(root.name, RVThereYetProfile.displayName(root))
        } finally {
            root.deleteRecursively()
        }
    }
}
