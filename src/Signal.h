#pragma once

#include <functional>
#include <vector>


template<typename... ARGS>
class Signal
{
public:
  // Debounced version of fire - Will fire once, and won't
  // fire again until debounced
  void emit(ARGS&&... args)
  {
    if (!_fire)
    {
      _fire = true;
      fire(std::forward<ARGS>(args)...);
    }
  }

  // Fire the event
  void fire(ARGS... args)
  {
    for(auto && callback : _callbacks)
    {
      callback(args...);
    }
  }

  // Allow the event to be emitted again
  void reset()
  {
    _fire = false;
  }

  void connect(std::function<void(ARGS...)> f)
  {
    _callbacks.push_back(f);
  }

  template<typename C, typename F>
  void connect(C * obj, F f)
  {
    _callbacks.push_back([obj, f](ARGS&... args){ (obj->*f)(args...); });
  }

private:
  std::vector<std::function<void(ARGS...)> > _callbacks;
  bool _fire = false;
};
