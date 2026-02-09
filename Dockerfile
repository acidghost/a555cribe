FROM ghcr.io/astral-sh/uv:0.8.11@sha256:8101ad825250a114e7bef89eefaa73c31e34e10ffbe5aff01562740bac97553c AS uv
FROM docker.io/library/python:3.14.3-slim-trixie@sha256:486b8092bfb12997e10d4920897213a06563449c951c5506c2a2cfaf591c599f
COPY --from=uv /uv /uvx /bin/
RUN useradd -u 1000 scribe && mkdir /cache && chown scribe:scribe /cache
WORKDIR /app
ENV HF_HOME=/cache
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project
ADD . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked
USER scribe
ENV PATH=/app/.venv/bin:$PATH
ENTRYPOINT ["a555cribe", "serve"]
