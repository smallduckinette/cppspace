#include "InputSubsystem.h"

InputSubsystem::InputSubsystem(sf::RenderWindow* window) : _window(window)
{
}

void InputSubsystem::run()
{
  sf::Event event;
  while (_window->pollEvent(event))
  {
    if (event.type == sf::Event::Closed)
    {
      _quit.fire();
    }
    else if (event.type == sf::Event::KeyPressed)
    {
      if (event.key.code == sf::Keyboard::Escape)
      {
        _quit.fire();
      }
    }
  }
}

Signal<>& InputSubsystem::onQuit()
{
  return _quit;
}
