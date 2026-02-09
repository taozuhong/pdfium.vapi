project('pdfium', ['vala', 'c'])

libraries = [
  dependency('gtk4', version: '>= 4.0.0', static: false),
  dependency('pdfium', version: '>= 100.0.0', static: false),
]

add_project_arguments(['--vapidir', meson.global_source_root()], language: 'vala')

gnome=import('gnome')
resources = gnome.compile_resources('resources', 'pdfium.gresource.xml')

sourcefiles = [
    'pdfium.vala',
    'application.vala'
]

executable('pdfium', sourcefiles, resources, dependencies: libraries, export_dynamic: false, install: false)
