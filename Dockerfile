# --- Build Container ---
FROM elixir:1.6.6-otp-21 as builder

ARG NAME
RUN test -n "$NAME"

# ENVs
ENV MIX_ENV=prod

# Define path ENVs
RUN mkdir /build && mkdir /release

## Build
WORKDIR /build

# Install Elixir Deps
RUN mix local.hex --force \
    && mix local.rebar --force

# Copying mix.exs
COPY mix.exs mix.lock ./
COPY apps/archiver_fetcher/mix.exs apps/archiver_fetcher/
COPY apps/archiver_google_drive/mix.exs apps/archiver_google_drive/
COPY apps/archiver_dropbox/mix.exs apps/archiver_dropbox/
COPY apps/archiver_shared/mix.exs apps/archiver_shared/
COPY apps/archiver_ui/mix.exs apps/archiver_ui/

# Fetch deps
RUN mix deps.get

# Copying Config files
COPY config ./config

COPY apps/archiver_fetcher/config/* apps/archiver_fetcher/config/
COPY apps/archiver_google_drive/config/* apps/archiver_google_drive/config/
COPY apps/archiver_dropbox/config/* apps/archiver_dropbox/config/
COPY apps/archiver_shared/config/* apps/archiver_shared/config/
COPY apps/archiver_ui/config/* apps/archiver_ui/config/

# Compile everything
RUN mix compile

# Main realease
ADD . .

RUN mix release --name=${NAME} --env=prod --executable

# Copy releases
RUN cp ./_build/prod/rel/${NAME}/bin/${NAME}.run /release/app.run \
    && rm -rf /build

WORKDIR /release

# --- Release Container ---
FROM elixir:1.6.6-otp-21 as runtime

ENV REPLACE_OS_VARS=true

RUN mkdir /release
WORKDIR /release

COPY --from=builder /release/app.run .
