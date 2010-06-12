Feature: Authorization
	As a Guest or User
	I want to have some restrictions
	So that I can feel save
	
	Scenario: View Guild as User
		Given a guild
		And I am a registered user
		And I am logged in
		When I go to the guildpage
		Then I should see "Guild"
		And I should see "Members"
		
	Scenario: View Guild as Guest
		Given a guild
		When I go to the guildpage
		Then I should see "Guild"
		And I should see "Members"
		
	Scenario: View Guild as Member
		Given a guild
		And I am a registered user
		And I am a "member" of the guild
		And I am logged in
		When I go to the guildpage
		Then I should see "Guild"
		And I should see "Members"
		And I should see "Raids"
		And I should see "Users"
	
	Scenario: Create Guild as Guest
		Given I am on the homepage
		When I go to a new guild
		Then I should see "Sorry, you are not allowed to access that page."
		
	Scenario: Sync Guild as Guest
		Given a guild
		When I go to actualize guild
		Then I should see "Sorry, you are not allowed to access that page."
	
	Scenario: Edit Guild as Guest
		Given a guild
		When I go to edit guild
		Then I should see "Sorry, you are not allowed to access that page."
		
	Scenario: Create Guild as User
		Given a guild
		And I am a registered user
		And I am logged in
		When I go to a new guild
		And fill in some guildinfos
		And I press "create"
		Then I should see "Guild was successfully created."
		
	Scenario: Sync Guild as manager
		Given a guild
		And I am a registered user
		And I am a "leader" of the guild
		And I am logged in
		And I am on the guildpage
		When I follow "Actualize"
		Then I should see "Guild will be updated soon"

	Scenario: Edit Guild as manager
		Given a guild
		And I am a registered user
		And I am a "leader" of the guild
		And I am logged in
		When I go to edit guild
		And fill in "guild_website" with "http://another.website.com"
		And I press "update"
		Then I should see "Guild was successfully updated."
		And I should see "http://another.website.com"
		
	Scenario: Join a guild with valid token
		Given a guild
		And I am a registered user
		And I am logged in
		When I join the guild with a valid token
		Then I should see "You have successfully joined this guild"
		And I should be a member of the guild
		
	Scenario: Join a guild with invalid token
		Given a guild
		And I am a registered user
		And I am logged in
		When I join the guild with a invalid token
		Then I should see "invalid token! Please contact your guildmanager"
		And I should not be a member of the guild
		
	
	
		
		
