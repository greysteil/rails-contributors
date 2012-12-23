class ApplicationController < ActionController::Base
  before_filter :trace_user_agent

private
  def set_time_constraints
    @window = if params[:window].present? && TimeConstraints.known_key?(params[:window])
      params[:window]
    else
      'all-time'
    end
    @since = TimeConstraints.since_for(@window)
  end

  BOTS_REGEXP = %r{
    Baidu         |
    Gigabot       |
    Openbot       |
    Google        |
    libwww-perl   |
    lwp-trivial   |
    msnbot        |
    SiteUptime    |
    Slurp         |
    WordPress     |
    ZIBB          |
    ZyBorg        |
    Yahoo         |
    Lycos_Spider  |
    Infoseek      |
    ia_archiver   |
    scoutjet      |
    nutch         |
    nuhk          |
    dts\ agent    |
    twiceler      |
    ask\ jeeves   |
    Webspider     |
    Daumoa        |
    MEGAUPLOAD    |
    Yammybot      |
    yacybot       |
    GingerCrawler |
    Yandex        |
    Gaisbot       |
    TweetmemeBot  |
    HttpClient    |
    DotBot        |
    80legs        |
    MLBot         |
    wasitup       |
    ichiro        |
    discobot      |
    bingbot       |
    yrspider
  }xi
  def trace_user_agent
    if request.user_agent =~ BOTS_REGEXP
      logger.info("(BOT) #{request.user_agent}")
    else
      logger.info("(BROWSER) #{request.user_agent}")
    end
  end

  def set_release
    if params[:release_id].present?
      @release = Release.find_by_param(params[:release_id])
      head :not_found unless @release
    end
  end
end
