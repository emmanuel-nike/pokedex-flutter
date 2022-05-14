# Pokedex

Welcome to the **Pokedex** project!

A Flutter application that allows interacting with Pokemons. I hope you like it!

## Project Details

### Designs

- You can access to the designs of the application from this [link](https://www.figma.com/file/vP3TT058xIqpOv5zv7cUg9/Pokedex-Assessment?node-id=32%3A83).
  - You need to have a Figma account to see the all details. So, please create one if you don't have.
- You can click the **Present** button from top right, to see different flows.

#### Pages

- Splash Screen
  - It is shown while application is starting.
- All Pokemons
  - Pokemons are fetched from this API: <https://pokeapi.co>
  - Pokemons are paginated.
  - For Pokemon
    - #001 -> **id**
    - **Bulbasaur** -> **name**
    - **Grass, Poison** -> from **types** field
  - For the image of a Pokemon, **sprites** > **other** > **official-artwork** > **front_default** was used.
  - All Pokemons will be listed on this tab.
  - A progress indicator (style it however you want) is shown while Pokemons are being fetched.
- Favourites
  - When a Pokemon is marked as favourite by clicking **Mark as favourite** button on the **Pokemon details page**, it is shown on this tab.
  - The number of Pokemons marked as favourite, is shown near the tab text as shown on designs.
  - Pokemons that are marked as favourite are persistent and the data can be stored on disk. So, after a Pokemon is marked as favourite, it is still shown under **Favourites** tab even after application is closed and started again.
- Pokemon details page
  - **SliverAppBar** was used for implementing the app bar of this page.
  - In order to calculate BMI this formula: **weight / (height^2)** was used.
  - In order to calculate **Avg. Power** under **Base stats**, this formula: **(Hp + Attack + Defense + Special Attack + Special Defense + Speed) / 6** was used.
  - **Remove from favourites** button removes the related Pokemon from the list shown on **Favourites** tab.

## Running Instructions

First ensure ``flutter doctor`` runs correctly and all necessary components for your platform is installed

### Running for Android

Start up your android emulator or connect an android device with debugging enabled and and ensure that the simulator shows up in ``flutter devices``. Run the command below

``flutter run``

This should detect the emulator or device, build the project and run it

### Running for iOS

Start up your ios simulator and ensure that the simulator shows up in ``flutter devices``. Run the command below

``flutter run``

This should detect the emulator or device, build the project and run it

## Libraries/Packages used

- **flutter_native_splash v2.1.2+1** For creating splash screen
- **http v0.13.3** for making http requests
- **provider v5.0.0** for state management
- **flutter_staggered_grid_view v0.6.1** for displaying the grid view used
- **cached_network_image v3.2.0** for loading and caching network images
- **palette_generator v0.3.2** for generating color palette for an image
- **flutter_svg v1.0.3** for manipulating and displaying svg assets
- **shared_preferences v2.0.13** for storing data locally in the device
- **mocktail v0.2.0** for creating mocks for tests
