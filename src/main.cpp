#include <SFML/Window.hpp>
#include <SFML/Graphics.hpp>
#include "InputSubsystem.h"
#include "Scene.h"

class MainScene : public Scene
{
public:
  explicit MainScene(sf::RenderWindow* window) : _window(window), _inputSubsystem(window)
  {
    _inputSubsystem.onQuit().connect([&]() { _window->close(); });
  }

  void run() override
  {
    _inputSubsystem.run();

    _window->clear();
    _window->display();
  }

private:
  sf::RenderWindow* _window;
  InputSubsystem _inputSubsystem;
};

int main()
{
  sf::RenderWindow window(sf::VideoMode(800, 600), "cppspace");
  window.setVerticalSyncEnabled(true);

  MainScene mainScene(&window);

  while (window.isOpen())
  {
    mainScene.run();
  }

  return 0;
}
