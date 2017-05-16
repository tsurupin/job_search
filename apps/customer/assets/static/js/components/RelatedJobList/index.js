import React from 'react';
import PropTypes from 'prop-types';
import { SubHeading } from 'components';
import { Wrapper, RelatedJobLink } from './styles';
import { Title, SubText } from 'components';

const RelatedJobList = ({ jobs }) => (
  <Wrapper>
    <SubHeading>Other Positions</SubHeading>
    {jobs.map(job => (
      <RelatedJobLink key={job.id} to={`/jobs/${job.id}`}>
        <Title>{job.title}</Title>
        <SubText>{job.area}</SubText>
      </RelatedJobLink>
        ))}
  </Wrapper>
  );


const propTypes = {
  jobs: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      title: PropTypes.string.isRequired,
      area: PropTypes.string.isRequired,
    }).isRequired,
  ).isRequired,
};

RelatedJobList.propTypes = propTypes;
export default RelatedJobList;
