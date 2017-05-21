import React, { Component } from 'react';
import Helmet from 'react-helmet';

import {
  JobIndexContainer,
} from 'containers';

class JobIndexPage extends Component {

  constructor(props) {
    super(props);
  }
  render() {
    return (
      <article>
        <Helmet title="Home" />
        <JobIndexContainer />
      </article>
    );
  }

}

export default JobIndexPage;
