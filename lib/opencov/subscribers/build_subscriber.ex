defmodule Librecov.Subscriber.BuildSubscriber do
  alias EventBus.Model.Event
  alias Librecov.Build

  def process({_topic, _id} = event_shadow) do
    try do
      event_shadow |> EventBus.fetch_event() |> process()
    after
      EventBus.mark_as_completed({__MODULE__, event_shadow})
    end
  end

  def process(%Event{topic: :inserted, data: %Build{completed: true, coverage: coverage} = build})
      when coverage > 0.0 do
    %Event{id: UUID.uuid1(), topic: :build_finished, data: build} |> EventBus.notify()
  end

  def process(%Event{topic: :updated, data: {%Build{completed: true} = build, %{coverage: _}}}) do
    %Event{id: UUID.uuid1(), topic: :build_finished, data: build} |> EventBus.notify()
  end

  def process(%Event{}) do
  end
end
