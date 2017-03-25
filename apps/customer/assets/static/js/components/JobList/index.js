import React, { PropTypes } from 'react';
import { JobItem, SubHeading } from 'components';
import Wrapper from './Wrapper';
import List from './List';

const propTypes = {
  jobs: PropTypes.array.isRequired,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired
};

const JobList = ({jobs, handleSwitchFavoriteStatus}) =>{

  return (
    <Wrapper>
      <SubHeading>{`${jobs.length} startups`}</SubHeading>
      {renderJobRows(jobs, handleSwitchFavoriteStatus)}
    </Wrapper>
  )
};

function renderJobRows(jobs, fnc) {
  return (
    <List>
      {
        jobs.map((job, index) => {
          const property = {...job, index, handleSwitchFavoriteStatus: fnc};
          return <JobItem key={job.id} {...property} />
        })
      }
    </List>
  )
}

JobList.propTypes = propTypes;
export default JobList;