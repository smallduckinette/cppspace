#pragma once

class Scene
{
public:
  virtual ~Scene() = default;

  virtual void run() = 0;
};
