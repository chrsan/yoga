project('yoga', 'c', 'cpp', 'cython')

subdir('extern')

py = import('python').find_installation(pure: false)

py.extension_module('core', 'yoga.pyx',
  cython_args: ['--module-name', 'core'],
  dependencies: yoga_dep,
  install: true,
  subdir: 'yoga',
)

python_sources = [
  '__init__.py',
  'core.pyi',
  'py.typed',
]

py.install_sources(python_sources,
  subdir: 'yoga',
)
