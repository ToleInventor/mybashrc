# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
alias greencoin-on="desktop && python3 greencoin_awake.py"
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias root-user="sudo su"
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
alias cls='clear'
alias web-dev='npm run dev -- --host'
create_flask() {
    # Check and create app.py
    [ ! -f app.py ] && touch app.py && echo "Created app.py"

    # Check and create requirements.txt
    [ ! -f requirements.txt ] && touch requirements.txt && echo "Created requirements.txt"

    # Create directories only if they don't exist (-p handles this safely)
    mkdir -p templates static && echo "Verified templates/ and static/ directories"

    # Check and create virtual environment
    if [ ! -d "venv" ]; then
        echo "Creating fresh virtual environment..."
        python3 -m venv venv
    else
        echo "Existing venv folder found."
    fi

    # Activate the environment safely
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
        echo "Virtual environment activated!"
    else
        echo "Error: venv/bin/activate not found. Is venv corrupted?"
    fi
}

alias mkuu="sudo"
alias super="mzee su"
alias mzee="sudo"
alias home="cd ~"
alias desktop="cd ~/Desktop"
alias documents="cd ~/Documents"
alias downloads="cd ~/Downloads"
alias pictures="cd ~/Pictures"
alias videos="cd ~/Videos"
alias music="cd ~/Music"
alias templates="cd ~/Templates"
alias public="cd ~/Public"
alias edit-commands="home && code ./.bashrc"
alias edit-styling='code ~/.themes/CustomWhite/gnome-shell/gnome-shell.css'
alias refresh="source ~/.bashrc"
alias apply-styling="ln -sf ~/.config/gtk-4.0/gtk.css ~/.config/gtk-3.0/gtk.css"
alias refresh="r"
alias and="&&"
alias adb-reverse="reverse"

reverse(){
    echo "Reversing adb connection... \n\n"
    echo "Enter port to be revered (default: 8081): "
    read port
    [ -z "$port" ] && port=8081
    adb reverse tcp:$port tcp:$port
}

r(){
	echo "Reloading terminal"
	source ~/.bashrc
	cls
	echo "Terminal reloaded successfully!"
}
commands() {
    grep -E '^alias [a-zA-Z0-9_-]+=' ~/.bashrc | sed -E 's/^alias ([^=]+)=.*/\1/' | sort
}
alias csk-vision="start-csk-vision"
alias hotspot="sudo /usr/local/bin/hotspot"
alias stop-hotspot="sudo /usr/local/bin/stop-hotspot"
stop-heavy() {
    echo "Stopping heavy background development services..."
    sudo systemctl stop docker containerd postgresql@18-main redis-server
    
    echo "Flushing system memory cache..."
    sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    
    echo "Done!"
}

start-csk-vision() {
	echo "Starting CSK vision 😂😂😂 \n\n"
	echo "Changing directory to csk-vision!!\n\n"
	cd /home/devtole/Desktop/csk-vision
	echo "Activating the virtual env. \n\n"	
	source ./venv/bin/activate
	echo "running app...\n\n"
	cd /home/devtole/Desktop/csk-vision/model-related-staff
	python webcam_test.py
}

vm() {
    echo "=== Killing all non-essential processes (preserving VirtualBox + system) ==="
    read -p "This will close most apps. Continue? [y/N] " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && echo "Aborted." && return 1

    # Whitelist: processes we NEVER kill (matched case-insensitively against comm)
    local keep='vbox|virtualbox|systemd|init|kthread|kworker|ksoftirqd|migration|watchdog|rcu_|dbus|Xorg|Xwayland|gnome|gdm|sddm|lightdm|login|getty|bash|zsh|sh|tmux|screen|sshd|sudo|polkit|udev|journald|logind|networkd|resolved|avahi|cron|atd|rsyslog|pulseaudio|pipewire|wireplumber|dbus-daemon'

    # Build list of PIDs to kill
    mapfile -t pids < <(
        ps -eo pid,comm --no-headers \
        | grep -Ev '^ *[0-9]+ \[.*\]' \
        | grep -Eiv "$keep" \
        | awk -v me=$$ -v pp=$PPID '$1 != me && $1 != pp {print $1}'
    )

    if [[ ${#pids[@]} -eq 0 ]]; then
        echo "Nothing to kill."
        return 0
    fi

    echo "Sending SIGTERM to ${#pids[@]} processes..."
    kill -TERM "${pids[@]}" 2>/dev/null

    # Wait up to 3 seconds for graceful shutdown
    for i in {1..3}; do
        sleep 1
        local remaining=()
        for pid in "${pids[@]}"; do
            kill -0 "$pid" 2>/dev/null && remaining+=("$pid")
        done
        [[ ${#remaining[@]} -eq 0 ]] && break
        pids=("${remaining[@]}")
    done

    # Force-kill anything still alive
    if [[ ${#pids[@]} -gt 0 ]]; then
        echo "Force-killing ${#pids[@]} stubborn processes..."
        kill -KILL "${pids[@]}" 2>/dev/null
    fi

    echo
    echo "=== Still running (top 25 by memory) ==="
    ps -eo pid,comm,%mem --sort=-%mem --no-headers | head -25
}

alias only-vm="vm"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/navigator
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Custom function to separate debug and release apps for bare React Native
setup_diff_app() {
    local original_dir
    original_dir=$(pwd)
    local target_dir=""

    # ---- Locate android/ ----
    if [ -d "android" ]; then
        target_dir="android"
    elif [ -d "../android" ]; then
        target_dir="../android"
    elif [[ "$original_dir" == */android || "$original_dir" == */android/* ]]; then
        target_dir="${original_dir%%/android*}/android"
    else
        echo "❌ Error: Could not find the 'android' folder in your current or parent directories."
        return 1
    fi

    cd "$target_dir" || return 1

    local gradle_file="app/build.gradle"
    local strings_file="app/src/main/res/values/strings.xml"
    local manifest_file="app/src/main/AndroidManifest.xml"

    # ---- Kotlin DSL guard ----
    if [ -f "app/build.gradle.kts" ]; then
        echo "❌ Error: This script supports Groovy build.gradle only (found build.gradle.kts)."
        cd "$original_dir"
        return 1
    fi

    if [ ! -f "$gradle_file" ] || [ ! -f "$strings_file" ] || [ ! -f "$manifest_file" ]; then
        echo "❌ Error: Missing core Android files. Are you sure this is a Bare React Native project?"
        cd "$original_dir"
        return 1
    fi

    # ---- Idempotency: only skip if DEBUG block already has applicationIdSuffix ----
    if awk '
            /^[[:space:]]*buildTypes[[:space:]]*\{/  { in_bt=1 }
            in_bt && /^[[:space:]]*debug[[:space:]]*\{/ { in_dbg=1 }
            in_dbg && /applicationIdSuffix/             { found=1; exit }
            in_dbg && /^[[:space:]]*\}/                 { in_dbg=0 }
            in_bt  && /^[[:space:]]*\}/                 { in_bt=0 }
            END { exit(found ? 0 : 1) }
        ' "$gradle_file"; then
        echo "⚠️  Debug applicationIdSuffix already configured. Nothing to do."
        cd "$original_dir"
        return 0
    fi

    # ---- Rewrite build.gradle + strings.xml via Python ----
    if ! python3 - "$gradle_file" "$strings_file" <<'PY'
import pathlib, re, sys
import xml.etree.ElementTree as ET

gradle_path  = pathlib.Path(sys.argv[1])
strings_path = pathlib.Path(sys.argv[2])

gradle  = gradle_path.read_text()
strings = ET.parse(strings_path).getroot()

name_node = strings.find("./string[@name='app_name']")
if name_node is None or not (name_node.text or "").strip():
    print("❌ Error: strings.xml has no non-empty app_name.")
    raise SystemExit(1)

app_name = re.sub(r"\s*\(Debug\)$", "", name_node.text.strip(), flags=re.IGNORECASE)
escaped  = app_name.replace("\\", "\\\\").replace('"', '\\"')


def build_types_span(contents):
    """Return (inner_start, inner_end) offsets of the buildTypes { ... } body."""
    bt = re.search(r"(?m)^[ \t]*buildTypes[ \t]*\{", contents)
    if bt is None:
        raise ValueError("Could not find buildTypes { } block.")
    depth = 0
    end = None
    for i in range(bt.end() - 1, len(contents)):
        ch = contents[i]
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                end = i
                break
    if end is None:
        raise ValueError("Unbalanced braces in buildTypes block.")
    return bt.end(), end


def add_to_build_type(contents, build_type, entries):
    bt_start, bt_end = build_types_span(contents)
    inner = contents[bt_start:bt_end]
    pat = re.compile(r"(?m)^([ \t]*)" + build_type + r"[ \t]*\{")
    m = pat.search(inner)
    if m is None:
        raise ValueError(f"Could not find '{build_type}' block inside buildTypes.")
    indent     = m.group(1) + "    "
    insert_at  = bt_start + m.end()
    addition   = "\n" + "\n".join(indent + e for e in entries)
    return contents[:insert_at] + addition + contents[insert_at:]


try:
    gradle = add_to_build_type(
        gradle, "debug",
        [
            'applicationIdSuffix ".debug"',
            f'resValue "string", "app_name", "{escaped}(Debug)"',
        ],
    )
    gradle = add_to_build_type(
        gradle, "release",
        [f'resValue "string", "app_name", "{escaped}"'],
    )
except ValueError as err:
    print(f"❌ Error: {err}")
    raise SystemExit(1)

gradle_path.write_text(gradle)

# Remove base app_name from strings.xml (line-scoped, tolerant of trailing whitespace)
strings_text = strings_path.read_text()
strings_text, n = re.subn(
    r'(?m)^[ \t]*<string\s+name="app_name"[^>]*>.*?</string>[ \t]*\r?\n',
    "",
    strings_text,
    count=1,
)
if n == 0:
    print("❌ Error: Failed to remove app_name from strings.xml.")
    raise SystemExit(1)
strings_path.write_text(strings_text)

# Warn about duplicate app_name in other values*/strings.xml (would break resValue)
dupes = []
for p in strings_path.parent.parent.glob("values*/strings.xml"):
    if p == strings_path:
        continue
    if re.search(r'<string\s+name="app_name"', p.read_text()):
        dupes.append(str(p))
if dupes:
    print("⚠️  Warning: 'app_name' also defined in:")
    for d in dupes:
        print(f"     {d}")
    print("   Remove it there or the build will fail with 'duplicate value for resource'.")
PY
    then
        cd "$original_dir"
        return 1
    fi

    # ---- Manifest: ensure android:label="@string/app_name" ----
    if ! grep -q 'android:label="@string/app_name"' "$manifest_file"; then
        if sed --version >/dev/null 2>&1; then
            sed -i 's|android:label="[^"]*"|android:label="@string/app_name"|g' "$manifest_file"
        else
            sed -i '' 's|android:label="[^"]*"|android:label="@string/app_name"|g' "$manifest_file"
        fi
    fi

    cd "$original_dir"
    echo "✅ Debug build: '<name> (Debug)' with suffix '.debug'."
    echo "   Release build: original app name."
}

alias build-app-debug="cd android && ./gradlew assembleDebug"
alias build-app-release="cd android && ./gradlew assembleRelease"
alias run-android="npx react-native run-android"

alias config-distinct="setup_diff_app"

# One-time setup: split APKs into v7a + v8a only, and tune Gradle for speed.
# Run from anywhere inside the RN project root. Idempotent — safe to re-run.
setup_abiapp() {
    local dir="$PWD"
    local root=""
    while [[ "$dir" != "/" ]]; do
        if [[ -x "$dir/android/gradlew" && -f "$dir/package.json" ]]; then
            root="$dir"
            break
        fi
        dir="$(dirname "$dir")"
    done
    if [[ -z "$root" ]]; then
        echo "ERROR: no React Native project (android/gradlew + package.json) found from $(pwd)" >&2
        return 1
    fi
    echo "Project root: $root"

    local app_gradle="$root/android/app/build.gradle"
    local app_gradle_kts="$root/android/app/build.gradle.kts"
    local gradle_props="$root/android/gradle.properties"

    [[ -f "$app_gradle" ]]     || { echo "ERROR: missing $app_gradle"; return 1; }
    [[ -f "$gradle_props" ]]   || { echo "ERROR: missing $gradle_props"; return 1; }

    # ---- 1. Enable ABI splits (v7a + v8a only, no universal) ----
    # Insert into the existing `android { ... }` block.
    if grep -q "splits[[:space:]]*{" "$app_gradle"; then
        echo "splits { } already present in build.gradle — leaving as-is"
    else
        local tmp
        tmp="$(mktemp)" || return 1
        awk '
            BEGIN { done=0 }
            /^android[[:space:]]*\{/ && !done {
                print
                print "    splits {"
                print "        abi {"
                print "            enable true"
                print "            reset()"
                print "            include \"armeabi-v7a\", \"arm64-v8a\""
                print "            universalApk false"
                print "        }"
                print "    }"
                done=1
                next
            }
            { print }
        ' "$app_gradle" > "$tmp" && mv "$tmp" "$app_gradle"
        echo "Added ABI splits (v7a + v8a, no universal APK) to app/build.gradle"
    fi

    # ---- 2. Speed tuning in android/gradle.properties ----
    # Only append keys that are missing, so we never clobber your values.
    local -a props=(
        "org.gradle.jvmargs=-Xmx2560m -XX:MaxMetaspaceSize=512m -Dfile.encoding=UTF-8"
        "org.gradle.parallel=false"
        "org.gradle.caching=true"
        "org.gradle.configuration-cache=false"
        "org.gradle.priority=low"
        "kotlin.incremental=true"
        "kotlin.incremental.android=true"
        "android.useAndroidX=true"
        "android.enableJetifier=false"
        "android.debug.obsoleteApi=false"
    )
    local p added=0
    for p in "${props[@]}"; do
        local key="${p%%=*}"
        if ! grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$gradle_props"; then
            printf '\n%s\n' "$p" >> "$gradle_props"
            echo "Added: $p"
            added=$((added + 1))
        fi
    done
    [[ $added -eq 0 ]] && echo "gradle.properties already tuned — no changes."

    # ---- 3. Force release to only emit v7a + v8a ----
    # reactNativeArchitectures picks which ABIs get compiled; restricting it
    # to the two we split on guarantees exactly two APKs after assembleRelease.
    if grep -qE "^[[:space:]]*reactNativeArchitectures[[:space:]]*=" "$gradle_props"; then
        sed -i -E 's|^[[:space:]]*reactNativeArchitectures[[:space:]]*=.*|reactNativeArchitectures=armeabi-v7a,arm64-v8a|' "$gradle_props"
        echo "Updated: reactNativeArchitectures=armeabi-v7a,arm64-v8a"
    else
        printf '\nreactNativeArchitectures=armeabi-v7a,arm64-v8a\n' >> "$gradle_props"
        echo "Added: reactNativeArchitectures=armeabi-v7a,arm64-v8a"
    fi

    echo ""
    echo "Done. Next run:  cd $root/android && ./gradlew assembleRelease"
    echo "Expected output: two APKs under app/build/outputs/apk/release/"
    echo "  app-armeabi-v7a-release.apk"
    echo "  app-arm64-v8a-release.apk"
}

alias optimise-app="setup_abiapp"
