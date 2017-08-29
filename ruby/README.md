# Ruby

We recommend deploying Ruby with Puma for best performance. The setup assumes that port 8080 is being used by Puma. See `start.sh` on how the `ENTRYPOINT=web` env variable can be used to start Puma; this can be set to `workers` to start background workers such as Sidekiq or DelayedJob.
