#!/usr/bin/env python3
"""Acuña / reutiliza un JWT HS256 GAIA para distintos entornos.

Todos los targets firman con la MISMA clave HS256 = base64decode(GAIA_JWT_SECRET)
(el JWT_SECRET real de los .env de integraciones/emisiones/monolito), pero
cada uno exige un set de claims distinto. Vigencia por defecto: 3 MESES (90
dias), y se REUTILIZA el token cacheado (por target) mientras le queden >7
dias de vigencia -- evita acunar uno nuevo en cada prueba.

Requiere la env var GAIA_JWT_SECRET con el secreto real (pidelo a tu equipo /
gestor de secretos, no lo hardcodees en este archivo).

Targets:
  qa-v2      (default) corevida-qa-v2: gateway + integraciones + siniestros-v2.
             Claims: sub/subject + type:access + user + validate:true + exp.
  emisiones  dev-ms-core-emisiones en local. Claims: sub + user + exp
             (el filtro NO exige roles/validate).
  monolito   dev-ms-core-core en local (contra QA). Claims: subject + user +
             validate:true + exp (subject/user deben existir en dbo.usuario).

Uso:
    python3 mint-token.py                                   # target=qa-v2 (compat)
    python3 mint-token.py --target emisiones
    python3 mint-token.py --target monolito --subject andresf.mendezv --user 100
    python3 mint-token.py --target qa-v2 --force            # fuerza uno nuevo
    python3 mint-token.py --target qa-v2 --info             # token + vencimiento
"""
import argparse
import base64
import hashlib
import hmac
import json
import os
import sys
import time

SKILL_DIR = os.path.dirname(os.path.abspath(__file__))
SECRET = os.environ.get("GAIA_JWT_SECRET")
if not SECRET:
    sys.exit("Falta la env var GAIA_JWT_SECRET (el JWT_SECRET real de integraciones/emisiones/monolito)")
VIGENCIA = 90 * 24 * 3600   # 3 meses
MARGEN = 7 * 24 * 3600      # regenerar si quedan menos de 7 dias

TARGETS = {
    "qa-v2": {
        "cache": "token-cache.txt",  # nombre historico, no renombrar (compat)
        "default_subject": "usuario",
        "default_user": 1,
        "claims": lambda subject, user, now, exp: {
            "sub": subject, "subject": subject, "type": "access",
            "user": user, "iat": now, "exp": exp, "validate": True,
        },
    },
    "emisiones": {
        "cache": "token-cache-emisiones.txt",
        "default_subject": "admin",
        "default_user": 1,
        "claims": lambda subject, user, now, exp: {
            "sub": subject, "user": user, "iat": now, "exp": exp,
        },
    },
    "monolito": {
        "cache": "token-cache-monolito.txt",
        "default_subject": "andresf.mendezv",
        "default_user": 100,
        "claims": lambda subject, user, now, exp: {
            "subject": subject, "user": user, "iat": now, "exp": exp,
            "validate": True,
        },
    },
}


def b64u(b):
    return base64.urlsafe_b64encode(b).rstrip(b"=").decode()


def exp_de(tok):
    try:
        p = tok.split(".")[1]
        p += "=" * (-len(p) % 4)
        return json.loads(base64.urlsafe_b64decode(p)).get("exp", 0)
    except Exception:
        return 0


def mint(target, subject, user):
    cfg = TARGETS[target]
    key = base64.b64decode(SECRET)
    now = int(time.time())
    exp = now + VIGENCIA
    h = b64u(b'{"alg":"HS256","typ":"JWT"}')
    p = b64u(json.dumps(cfg["claims"](subject, user, now, exp),
                        separators=(',', ':')).encode())
    sig = b64u(hmac.new(key, (h + "." + p).encode(), hashlib.sha256).digest())
    return f"{h}.{p}.{sig}"


def obtener(target, subject, user, force=False):
    cfg = TARGETS[target]
    cache_path = os.path.join(SKILL_DIR, cfg["cache"])
    now = int(time.time())
    if not force and os.path.exists(cache_path):
        cached = open(cache_path).read().strip()
        if cached and exp_de(cached) - now > MARGEN:
            return cached
    tok = mint(target, subject, user)
    open(cache_path, "w").write(tok)
    return tok


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--target", choices=list(TARGETS), default="qa-v2")
    ap.add_argument("--subject", default=None)
    ap.add_argument("--user", default=None)
    ap.add_argument("--force", action="store_true")
    ap.add_argument("--info", action="store_true")
    args = ap.parse_args()

    cfg = TARGETS[args.target]
    subject = args.subject or cfg["default_subject"]
    user = args.user or cfg["default_user"]

    tok = obtener(args.target, subject, user, force=args.force)
    if args.info:
        print(tok)
        print("Target:", args.target)
        print("Vence (UTC):", time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(exp_de(tok))))
    else:
        print(tok)
