require 'mechanize'

class XmasLylicMaker < Mechanize

  SONGS_URL = "http://jpop.ninpou.jp/field/qurisumas.html"
  LYRICS_URL = "http://www.uta-net.com/"
  NARROW_BY_SONG = 2

  def initialize
    super
  end

  def remix_lylics
    lyrics = songs_list.map do |song|
      result_page(song).search('.td5').map { |list| list.text } if result_page(song)
    end
    puts lyrics.flatten.uniq.shuffle!.shift(13)
  end

  private

  def songs_page
    get(SONGS_URL)
  end

  def search_page
    get(LYRICS_URL)
  end

  def result_page(song_name)
    begin
      search_page.form_with(id: 'search_form') do |form|
        form.Keyword = song_name
        form.field_with(name: "Aselect").value = NARROW_BY_SONG
      end.submit
    rescue
    end
  end

  def songs_list
    songs_page.search('h3').map do |song_name|
      text = song_name.text
      text.slice!(0)
      text
    end
  end

end

XmasLylicMaker.new.remix_lylics

