defmodule FoodGeek.Factory do
  alias FoodGeek.Repo

  # Factories

  # Default password "password" for test environment
  @password_hash "$argon2id$v=19$m=256,t=1,p=4$gIYbmB/ajfcIMC2RMjecRg$B1pP2Kpbxtxq8HynLDK+io0bNe0XvPufiTQ+SATnJoU"

  def build(:user) do
    %FoodGeek.Accounts.User{
      email: "hello#{System.unique_integer()}@example.com",
      name: "James Dean",
      password_hash: @password_hash
    }
  end

  def build(:recipe) do
    %FoodGeek.Cookbook.Recipe{
      title: "Some dish",
      description: "Very tasty food",
      number_of_servings: 4,
      active_time_in_min: 30,
      total_time_in_min: 40,
      image: %{
        file_name: "food.jpeg",
        updated_at: ~N[2020-05-06 08:41:12]
      }
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def attributes(factory_name, attributes \\ []) do
    build(factory_name, attributes) |> Map.from_struct()
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert!(build(factory_name, attributes))
  end
end
