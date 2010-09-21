on run
    tell application "Finder" to set inputFiles to selection
    rename_case(inputFiles)
end run

on open(inputFiles)
    rename_case(inputFiles)
end open

on only_regular_files(theFiles)
    set theFilesRegular to {}
    tell application "Finder"
        repeat with theFile in theFiles
            if the URL of theFile does not end with "/" then
                set end of theFilesRegular to theFile
            end if
        end repeat
    end tell
    return theFilesRegular
end only_regular_files

on rename_case(inputFiles)
    set inputFiles to my only_regular_files(inputFiles)
    if length of inputFiles is equal to 0 then return
    tell application "Finder"
        display dialog "Are you sure you want to rename these " & (length of inputFiles) & " files?" with icon caution
        set homePath to the POSIX path of (get path to home folder)
        set renameCommand to "/Library/Frameworks/Python.framework/Versions/Current/bin/python " & homePath & ".local/bin/rename-case"
        set caseTypes to paragraphs of (do shell script renameCommand & " -L")
        set caseType to (choose from list caseTypes with prompt "Choose case:")
        if caseType is false then return
        set renameCommand to renameCommand & " -C " & caseType
        repeat with inputFile in inputFiles
            set renameCommand to renameCommand & " " & quoted form of POSIX path of (inputFile as alias)
        end repeat
        set renamedFilenames to paragraphs of (do shell script renameCommand)
        set renamedFiles to {}
        repeat with renamedFilename in renamedFilenames
            set end of renamedFiles to (my POSIX file renamedFilename)
        end repeat
        reveal renamedFiles
    end tell
end rename_case
