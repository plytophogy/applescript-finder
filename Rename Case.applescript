on regular_files(_files)
    set _regular to {}
    tell application "Finder"
        repeat with _file in _files
            if the URL of _file does not end with "/" then
                set end of _regular to _file
            end if
        end repeat
    end tell
    return _regular
end regular_files

on paths_to_files(_paths)
    set _files to {}
    repeat with _path in _paths
        set end of _files to POSIX file _path
    end repeat
    return _files
end paths_to_files

on rename_case(_files)

    set _files to regular_files(_files)
    if (count of _files) is equal to 0 then return

    tell application "Finder"
        display dialog "Are you sure you want to rename these " & (count of _files) & " files?" with icon caution

        set _command to "rename-case"

        set _cases to paragraphs of (do shell script _command & " -L")

        set _case to (choose from list _cases with prompt "Choose case:")
        if _case is false then return

        set _command to _command & " -C " & _case

        repeat with _file in _files
            set _command to _command & " " & quoted form of (POSIX path of (_file as alias))
        end repeat

        reveal my paths_to_files(paragraphs of (do shell script _command))
    end tell

end rename_case

on open (_files)
    rename_case(_files)
end open

on run
    tell application "Finder" to set _files to selection
    rename_case(_files)
end run
