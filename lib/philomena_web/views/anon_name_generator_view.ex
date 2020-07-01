defmodule PhilomenaWeb.AnonNameGeneratorView do
  use PhilomenaWeb, :view
  use Bitwise

  alias Philomena.Servers.Config

  def generated_anon_name(key) do
    config = config()

    first_name_index = high_byte(key)
    second_name_index = low_byte(key)

    # Set name parts
    first_name = at(first_name(config), first_name_index)
    second_name = at(second_name(config), second_name_index)

    # Make a name
    anon_name(first_name, second_name)
  end

  # generate name for the character.
  defp anon_name(first_name, second_name) do
    first_name <>
        space_separator(first_name) <>
        second_name
  end

  # Pick an element from an enumerable at the specified position,
  # wrapping around as appropriate.
  defp at(list, position) do
    length = Enum.count(list)
    position = rem(position, length)

    Enum.at(list, position)
  end

  defp high_byte(word), do: (word >>> 8) &&& 0xFF
  defp low_byte(word), do: word &&& 0xFF

  defp space_separator(""), do: ""
  defp space_separator(_), do: " "

  defp first_name(%{"first_name" => first_name}), do: first_name
  defp second_name(%{"second_name" => second_name}), do: second_name

  defp config, do: Config.get(:anon_name)
end
