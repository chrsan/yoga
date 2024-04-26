yoga_inc = include_directories('yoga')

yoga_sources = files(
  'yoga/yoga/YGConfig.cpp',
  'yoga/yoga/YGEnums.cpp',
  'yoga/yoga/YGNode.cpp',
  'yoga/yoga/YGNodeLayout.cpp',
  'yoga/yoga/YGNodeStyle.cpp',
  'yoga/yoga/YGPixelGrid.cpp',
  'yoga/yoga/YGValue.cpp',
  'yoga/yoga/algorithm/AbsoluteLayout.cpp',
  'yoga/yoga/algorithm/Baseline.cpp',
  'yoga/yoga/algorithm/Cache.cpp',
  'yoga/yoga/algorithm/CalculateLayout.cpp',
  'yoga/yoga/algorithm/FlexLine.cpp',
  'yoga/yoga/algorithm/PixelGrid.cpp',
  'yoga/yoga/config/Config.cpp',
  'yoga/yoga/debug/AssertFatal.cpp',
  'yoga/yoga/debug/Log.cpp',
  'yoga/yoga/event/event.cpp',
  'yoga/yoga/node/LayoutResults.cpp',
  'yoga/yoga/node/Node.cpp',
)

yoga_lib = static_library('yoga', yoga_sources,
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
