import fetch from 'node-fetch';
import {
  GraphQLID,
  GraphQLList,
  GraphQLNonNull,
  GraphQLObjectType,
  GraphQLSchema,
  GraphQLString,
} from 'graphql';
import {
  fromGlobalId,
  globalIdField,
  nodeDefinitions,
} from 'graphql-relay';

const BASE_URL = 'http://localhost:8000';

function getJSONFromRelativeURL(relativeURL) {
  return fetch(`${BASE_URL}${relativeURL}`)
    .then(res => res.json());
}

function getPeople() {
  return getJSONFromRelativeURL('/people/')
    .then(json => json.people);
}

function getPerson(id) {
  return getPersonByURL(`/people/${id}/`);
}

function getPersonByURL(relativeURL) {
  return getJSONFromRelativeURL(relativeURL)
    .then(json => json.person);
}

const {
  nodeField,
  nodeInterface,
} = nodeDefinitions(
  // A method that maps from a global id to an object
  (globalId) => {
    const {id, type} = fromGlobalId(globalId);
    if (type === 'Person') {
      return getPersonPromiseById(id);
    }
  },
  // A method that maps from an object to a type
  (obj) => {
    if (obj.hasOwnProperty('username')) {
      return PersonType;
    }
  }
);

const PersonType = new GraphQLObjectType({
  name: 'Person',
  description: 'Somebody that you used to know',
  fields: () => ({
    id: globalIdField('Person'),
    firstName: {
      type: GraphQLString,
      description: 'What you yell at me',
      resolve: obj => obj.first_name,
    },
    lastName: {
      type: GraphQLString,
      description: 'What you yell at me when I\'ve been bad',
      resolve: obj => obj.last_name,
    },
    fullName: {
      type: GraphQLString,
      description: 'A name sandwich',
      resolve: obj => `${obj.first_name} ${obj.last_name}`,
    },
    email: {
      type: GraphQLString,
      description: 'Where to send junk mail',
    },
    username: {
      type: GraphQLString,
      description: 'Log in as this',
    },
    friends: {
      type: new GraphQLList(PersonType),
      description: 'People who lent you money',
      resolve: obj => obj.friends.map(getPersonByURL),
    },
  }),
  interfaces: [nodeInterface],
});

const QueryType = new GraphQLObjectType({
  name: 'Query',
  description: 'The root of all... queries',
  fields: () => ({
    allPeople: {
      type: new GraphQLList(PersonType),
      description: 'Everyone, everywhere',
      resolve: () => getPeople(),
    },
    node: nodeField,
    person: {
      type: PersonType,
      args: {
        id: {type: new GraphQLNonNull(GraphQLID)},
      },
      resolve: (root, args) => getPerson(args.id),
    },
  }),
});

export default new GraphQLSchema({
  query: QueryType,
});
