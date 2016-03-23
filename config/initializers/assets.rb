# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.css
                                                  font-awesome.min.css
                                                  ionicons.min.css
                                                  datatables/dataTables.bootstrap.css 
                                                  jquery.multiselect.css
                                                  jqgrid_style/ui.jqgrid.css 
                                                  jquery-ui.css
                                                  AdminLTE.css 
                                                  custom_popup.css
                                                  radiologist.css
                                                  jquery.min.js 
                                                  bootstrap.min.js
                                                  jqgrid/grid.locale-en.js
                                                  jqgrid/jquery.jqGrid.js
                                                  plugins/datatables/jquery.dataTables.js
                                                  plugins/datatables/dataTables.bootstrap.js
                                                  AdminLTE/app.js
                                                  jquery-ui-1.10.3.min.js 
                                                  jquery.multiselect.js
												  appHead1.js
												  jquery.jqGrid.run.js
												  jquery.jqGrid.search.run.js)


#config.assets.precompile += [Rails.root.to_s + '/vendor/assets/stylesheets/custom/*.gif']
Dir.glob("#{Rails.root}/app/assets/images/**/").each do |path|
  Rails.application.config.assets.paths << path
end

Dir.glob("#{Rails.root}/app/assets/js").each do |path|
  Rails.application.config.assets.paths << path
end

