project('yoga', 'c', 'cpp')

yoga_inc = include_directories('.')

yoga_sources = files(
  'yoga/YGConfig.cpp',
  'yoga/YGEnums.cpp',
  'yoga/YGNode.cpp',
  'yoga/YGNodeLayout.cpp',
  'yoga/YGNodeStyle.cpp',
  'yoga/YGPixelGrid.cpp',
  'yoga/YGValue.cpp',
  'yoga/algorithm/AbsoluteLayout.cpp',
  'yoga/algorithm/Baseline.cpp',
  'yoga/algorithm/Cache.cpp',
  'yoga/algorithm/CalculateLayout.cpp',
  'yoga/algorithm/FlexLine.cpp',
  'yoga/algorithm/PixelGrid.cpp',
  'yoga/config/Config.cpp',
  'yoga/debug/AssertFatal.cpp',
  'yoga/debug/Log.cpp',
  'yoga/event/event.cpp',
  'yoga/node/LayoutResults.cpp',
  'yoga/node/Node.cpp',
)

yoga_lib = static_library(
  'yoga',
  yoga_sources,
  cpp_args: [
    '-std=c++20',
    '-fno-exceptions',
    '-fno-rtti',
  ],
  include_directories: yoga_inc,
)

yoga_dep = declare_dependency(
  include_directories: yoga_inc,
  link_with: yoga_lib,
)
