#pragma once

#include <SFML/Graphics.hpp>
#include "Signal.h"

class InputSubsystem
{
public:
  explicit InputSubsystem(sf::RenderWindow* window);

  void run();

  Signal<>& onQuit();

private:
  sf::RenderWindow* _window;
  Signal<> _quit;
};
