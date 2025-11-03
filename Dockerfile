FROM ghcr.io/astral-sh/uv:0.9.7@sha256:ba4857bf2a068e9bc0e64eed8563b065908a4cd6bfb66b531a9c424c8e25e142 AS uv
FROM docker.io/library/python:3.13.7-slim-trixie@sha256:8220ccec22e88cddd9a541cacd1bf48423bda8cdeb1015249e4b298edf86cdc7
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
