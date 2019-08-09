# require 'spec_helper'
#
# feature 'A user visits a document', js: true do
#   include UserHelper
#   scenario 'they see a list annotations, sorted by position' do
#
#     password = 'foobar'
#     user = create(:user, password: password)
#     user.confirm!
#
#     visit new_user_session_path
#     find(:css, "input#user_email").set user.email
#     find(:css, "input#user_password").set password
#     binding.pry
#     find(:css, "input.btn.btn-primary").click
#
#     page.save_screenshot('screenshot.png')
#
#     document = create(
#       :document,
#       user: user,
#       text: File.read('spec/support/example_files/example.html'),
#     )
#
#     visit document_path(document)
#
#     expect(page).to have_annotation_list_item('bviwbw', 1)
#     # expect(page).to have_annotation_list_item('jovnia', 2)
#   end
# end
#
# def has_annotation_list_item?(id, position)
#   has_content?([
#     'ul#annotation-list',
#     "li:nth-child(#{position})",
#     "span[data-highlight='#hl#{id}']"
#   ].join(' '))
# end
