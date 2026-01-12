FROM ghcr.io/astral-sh/uv:0.9.24@sha256:816fdce3387ed2142e37d2e56e1b1b97ccc1ea87731ba199dc8a25c04e4997c5 AS uv
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
