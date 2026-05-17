"""Helpers for generating runnable Nomad resource targets."""

def write_nomad_runner(ctx, src, args):
    executable = ctx.outputs.executable
    nomad = ctx.toolchains["//nomad:toolchain_type"].nomad

    ctx.actions.write(
        output = executable,
        content = """#!/usr/bin/env bash
set -euo pipefail

runfiles_root="${RUNFILES_DIR:-${0}.runfiles}"
find_runfile() {
    local path="$1"
    local candidate

    if [[ -n "${RUNFILES_MANIFEST_FILE:-}" ]]; then
        candidate="$(grep -m1 "^${path} " "${RUNFILES_MANIFEST_FILE}" | cut -d ' ' -f 2-)"
        if [[ -n "${candidate}" ]]; then
            printf '%%s\\n' "${candidate}"
            return 0
        fi
    fi

    for candidate in "${runfiles_root}/${path}" "${runfiles_root}/_main/${path}"; do
        if [[ -e "${candidate}" ]]; then
            printf '%%s\\n' "${candidate}"
            return 0
        fi
    done

    find "${runfiles_root}" -path "*/${path}" -print -quit
}

nomad="$(find_runfile "%s")"
src="$(find_runfile "%s")"

exec "${nomad}" %s "${src}"
""" % (nomad.short_path, src.short_path, " ".join(args)),
        is_executable = True,
    )

    return executable, nomad
