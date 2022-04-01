# Roadmap Bokken

Here are presented the most important features to develop for the platform to be able to be used.

Features are ordered from highest priority to lowest.

## 1. Session Booking

This feature will allow automating the booking of a session. The process would be as follows:

1. An admin (which is a user profile to add) will book a session to a certain day, give a deadline for the mentors to express their availability

2. When the deadline expires, the guardians will be notified via email to signup their ninjas. The open number of slots will be equal to the number of available mentors

3. The guardians will signup their ninjas until the given deadline if they wish to

4. When signups close and the pairing are finalized, the guardians whose ninjas have been selected will receive an invitation via email


An admin will be the user profile with the most permitions, like:

- Book sessions
- Change ninja's belt without all requirements being met
- Pair ninjas with mentors (including overwriting automatic pairings)
- View the full pairings ninja / mentors, and waiting list
- ...

## 2. Mentor / Ninja Pairing

After signups for ninjas close, the admin will be able to request an automatic pairing between mentor / ninja.

A good pairing should obbey the following:

1. First come first serve. Ninjas who signup first have priority over those who signup later

2. Ninjas should only be paired with mentors who teach their technology

3. The number of served ninjas should be maximum

4. Mentors still in recruitment will be paired with another mentor / ninja

5. A mentor could be paired with more than one ninja (however not automatically)

A penalty system should be implemented, such that ninjas who fail to show up will be penalized in a given number of spots in the queue for the next session.

More formally, a pairing would be described by

- Ninja
- Mentor(s) 
- Session
- Timestamp of creation
- Timestamp of last edition

There would have to be an API endpoint which generates these pairings

## 3. Session Summaries

After each session, the mentor paired with a ninja should write a brief summary of the work carried out during the session (similar to what we have in Notion).

This summaries will be public to all mentors and admins, as well as to the ninja's guardian.

More formally, a summary would consist of

- Ninja
- Mentor (only allow one mentor to make a summary)
- Session
- Summary
- Timestamp of creation
- Timestamp of last edition
  
  
## 4. Projects

There should be a way in the platform to see the ninjas' projects. For Scratch, this would be achieved using the [Scratch API](https://en.scratch-wiki.info/wiki/Scratch_API). For Python, right now [Replit](https://replit.com/) does not have such an API, so another solution would have to be created (probably using Github for more advanced ninjas).

The projects could have different visibility. If the ninja wants it public (and the guardian has allowed them to do that), everyone within the platform will be able to see it. If it is private, only the ninja, the guardian and the mentors will have access to it.

## 5. Gamification

Gamification would be similar to that of [SEI](https://seium.org), in which ninjas could gain badges based on the work carried out. The ninjas with most badges could even get a prize.

The badges should be related to programming, for example:

- Writing my first project in Scratch
- Writing an "Hello World" program in Python
- Pushing a commit to a Git repository
- Creating a website
- Interacting with a database
- ...

The mentors would be responsible for the giving of the badges. The badges could also be used as a criteria to advance belt.

## 6. Recruitment

The platform could be where new mentors sign up. They sign up by creating a mentor account. From there, whoever is responsible for recruitment (will be an admin in the system) will contact them to setup a meeting and follow the normal recruitment procedure.

When the recruitment process finishes, their account could be verified to signal them being fully integrated with the team.