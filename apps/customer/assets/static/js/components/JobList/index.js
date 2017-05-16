import React from 'react';
import PropTypes from 'prop-types';
import { JobItem, SubHeading } from 'components';
import { Wrapper, List } from './styles';
import Infinite from 'react-infinite';

const propTypes = {
  jobs: PropTypes.array.isRequired,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired,
};

const JobList = ({ jobs, total, handleSwitchFavoriteStatus, handleLoad }) => (
  <Wrapper>
    <SubHeading>{`${total} startups`}</SubHeading>
    <Infinite
      infiniteLoadBeginEdgeOffset={500}
      onInfiniteLoad={handleLoad}
      containerHeight={2000}
      preloadBatchSize={Infinite.containerHeightScaleFactor(2)}
      elementHeight={200}
    >
      {renderJobRows(jobs, handleSwitchFavoriteStatus)}
    </Infinite>
  </Wrapper>
  );

function renderJobRows(jobs, fnc) {
  return (
    <List>
      {
        jobs.map((job, index) => {
          const property = { ...job, index, handleSwitchFavoriteStatus: fnc };
          return <JobItem key={job.id} {...property} />;
        })
      }
    </List>
  );
}

JobList.propTypes = propTypes;
export default JobList;
