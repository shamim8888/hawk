#======================================================================
#                        HA Web Konsole (Hawk)
# --------------------------------------------------------------------
#            A web-based GUI for managing and monitoring the
#          Pacemaker High-Availability cluster resource manager
#
# Copyright (c) 2009-2013 SUSE LLC, All Rights Reserved.
#
# Author: Tim Serong <tserong@suse.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it would be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Further, this software is distributed without any warranty that it is
# free of the rightful claim of any third person regarding infringement
# or the like.  Any license provided herein, whether implied or
# otherwise, applies only to this software file.  Patent licenses, if
# any, provided herein do not apply to combinations of this program with
# other software, or any other product whatsoever.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write the Free Software Foundation,
# Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
#
#======================================================================

require File.expand_path('../boot', __FILE__)

module Hawk
  class Application < Rails::Application
    config.autoload_paths += [
      config.root.join('lib')
    ]

    config.encoding = 'utf-8'
    config.time_zone = 'UTC'

    config.active_support.escape_html_entities_in_json = true

    config.app_middleware.delete 'ActiveRecord::ConnectionAdapters::ConnectionManagement'
    config.app_middleware.delete 'ActiveRecord::QueryCache'

    config.middleware.use 'PerRequestCache'

    config.generators do |g|
      g.assets false
      g.helper false
      g.orm :active_record
      g.template_engine :haml
      g.test_framework :rspec, fixture: true
      g.fallbacks[:rspec] = :test_unit
    end

    # TODO(should): confirm under exactly what circumstances these two are hit
    config.action_dispatch.rescue_responses.merge!('CibObject::RecordNotFound' => :not_found)
    config.action_dispatch.rescue_responses.merge!('CibObject::PermissionDenied' => :forbidden)
  end
end
