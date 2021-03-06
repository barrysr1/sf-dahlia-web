do ->
  'use strict'
  describe 'ShortFormNavigationService', ->
    ShortFormNavigationService = undefined
    $translate = {}
    $auth = {}
    $modal = {}
    Upload = {}
    uuid = {v4: jasmine.createSpy()}
    $state = undefined
    fakeShortFormApplicationService =
      application:
        householdMembers: []
    fakeLoadingOverlayService =
      start: -> null
      stop: -> null
    sections = [
      { name: 'You', pages: [
          'name',
          'contact',
          'verify-address',
          'alternate-contact-type',
          'alternate-contact-name',
          'alternate-contact-phone-address',
        ]
      },
      { name: 'Household', pages: [
          'household-intro',
          'household-overview',
          'household-members',
          'household-member-form',
          'household-member-form-edit'
        ]
      },
      { name: 'Preferences', pages: [
          'preferences-programs',
          'live-work-preference',
          'general-lottery-notice'
        ]
      },
      { name: 'Income', pages: [
          'income-vouchers'
          'income'
        ]
      },
      { name: 'Review', pages: [
          'review-optional',
          'review-summary',
          'review-sign-in',
          'review-terms'
        ]
      }
    ]

    beforeEach module('ui.router')
    beforeEach module('dahlia.services', ($provide)->
      $provide.value '$translate', $translate
      $provide.value '$auth', $auth
      $provide.value '$modal', $modal
      $provide.value 'Upload', Upload
      $provide.value 'uuid', uuid
      $provide.value 'bsLoadingOverlayService', fakeLoadingOverlayService
      $provide.value 'ShortFormApplicationService', fakeShortFormApplicationService
      return
    )

    beforeEach inject((_ShortFormNavigationService_, _$state_, _ShortFormApplicationService_) ->
      $state = _$state_
      ShortFormNavigationService = _ShortFormNavigationService_
      return
    )

    describe 'Service setup', ->
      it 'initializes defaults', ->
        expect(ShortFormNavigationService.sections).toEqual sections

    describe 'hasNav', ->
      it 'checks if section does not have nav enabled', ->
        $state.current.name = 'dahlia.short-form-welcome.intro'
        hasNav = ShortFormNavigationService.hasNav()
        expect(hasNav).toEqual false
      it 'checks if section has nav enabled', ->
        $state.current.name = 'dahlia.short-form-application.name'
        hasNav = ShortFormNavigationService.hasNav()
        expect(hasNav).toEqual true

    describe 'hasBackButton', ->
      it 'checks if section does not have back button enabled', ->
        $state.current.name = 'dahlia.short-form-welcome.intro'
        hasNav = ShortFormNavigationService.hasBackButton()
        expect(hasNav).toEqual false
      it 'checks if section has back button enabled', ->
        $state.current.name = 'dahlia.short-form-application.contact'
        hasNav = ShortFormNavigationService.hasBackButton()
        expect(hasNav).toEqual true

    describe 'activeSection', ->
      it 'gets the active section of the current page', ->
        $state.current.name = 'dahlia.short-form-application.preferences-programs'
        activeSection = ShortFormNavigationService.activeSection()
        expect(activeSection.name).toEqual 'Preferences'

    describe 'backPageState', ->
      it 'gets the previous page href to be used by the back button', ->
        $state.current.name = 'dahlia.short-form-application.contact'
        previousState = ShortFormNavigationService.backPageState()
        expect(previousState).toEqual $state.href('dahlia.short-form-application.name')

    describe 'previousPage', ->
      it 'gets the name of the previous page based on your current page', ->
        $state.current.name = 'dahlia.short-form-application.contact'
        previousPage = ShortFormNavigationService.previousPage()
        expect(previousPage).toEqual 'name'

    describe 'getLandingPage', ->
      it 'gets the first page of the section if it\'s not Household', ->
        section = ShortFormNavigationService.sections[0]
        page = ShortFormNavigationService.getLandingPage(section)
        expect(page).toEqual section.pages[0]
      it 'gets household intro page if no householdMembers', ->
        householdSection = ShortFormNavigationService.sections[1]
        page = ShortFormNavigationService.getLandingPage(householdSection)
        expect(page).toEqual 'household-intro'
      it 'gets household members page if householdMembers', ->
        householdSection = ShortFormNavigationService.sections[1]
        fakeShortFormApplicationService.application.householdMembers = [{firstName: 'Joe'}]
        page = ShortFormNavigationService.getLandingPage(householdSection)
        expect(page).toEqual 'household-members'
